# frozen_string_literal: true

# Adds a progress entry to a reading.
#
# - `start_over: true` begins a new attempt: the reading's attempt counter grows,
#   and the entry opens a new progress bar.
# - Entries of the same day and attempt that adjoin the new one (one's `to_page` equals
#   another's `from_page`) are merged with it into a single entry; the earliest one survives.
#   Their notes are glued together in the order they were entered, every part marked
#   with the time of entering: "14:11 Chapter 4\n\n16:20 Chapter 5".
#
# Returns the saved entry (the surviving one, if a merge happened)
# or an unsaved entry with validation errors.
#
# See doc/features/reading-progress.md
class ReadingProgressCreation
  NOTE_SEPARATOR = "\n\n"
  # A note starting with a time mark has already been glued by a previous merge
  TIME_MARK = /\A\d{2}:\d{2} /

  def self.run(reading, params, start_over: false)
    new(reading, params, start_over).run
  end

  def initialize(reading, params, start_over)
    @reading = reading
    @start_over = start_over
    attempt = start_over ? reading.attempt + 1 : reading.attempt
    @progress = ReadingProgress.new(params.merge(reading: reading, attempt: attempt))
  end

  def run
    return @progress if @progress.invalid?

    ReadingProgress.transaction do
      @reading.update!(attempt: @progress.attempt) if @start_over

      adjoining = adjoining_entries
      adjoining.empty? ? @progress.tap(&:save!) : merge(adjoining)
    end
  end

  private

  def adjoining_entries
    @reading.progresses
      .where(date: @progress.date, attempt: @progress.attempt)
      .where("to_page = :from OR from_page = :to", from: @progress.from_page, to: @progress.to_page)
      .order(:created_at, :id)
      .to_a
  end

  def merge(adjoining)
    survivor, *absorbed = adjoining
    entries = [*adjoining, @progress]

    survivor.assign_attributes(
      from_page: entries.map(&:from_page).min,
      to_page: entries.map(&:to_page).max,
      note: entries.filter_map { |entry| marked_note(entry) }.join(NOTE_SEPARATOR)
    )
    absorbed.each(&:destroy!)
    survivor.save!
    survivor
  end

  def marked_note(entry)
    return if entry.note.blank?
    return entry.note if entry.note.match?(TIME_MARK)

    entered_at = entry.created_at || Time.current
    "#{entered_at.strftime("%H:%M")} #{entry.note}"
  end
end
