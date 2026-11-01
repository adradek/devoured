# frozen_string_literal: true

# Turns progress entries of a reading into progress bars: one bar per attempt,
# every entry is a segment placed by its bookmark pages (percent of `total_pages`).
#
# - Each reading day gets one of PALETTE_SIZE colors, picked at random but different from
#   the previous day's. The randomness is seeded by the reading and the date,
#   so colors stay the same between page loads.
# - Re-read pages are counted once (union of segments).
# - Pages beyond `total_pages` are cut off.
#
# See doc/features/reading-progress.md
class ReadingProgressMap
  # Must match the number of .progress-color-N classes in books.scss
  PALETTE_SIZE = 5

  Segment = Data.define(:left, :width, :color, :hint)

  Bar = Data.define(:attempt, :current, :first_date, :last_date, :pages_read, :total_pages, :segments) do
    def percent
      (pages_read * 100.0 / total_pages).round if total_pages
    end

    def dates
      [first_date, last_date].uniq.map { it.strftime("%d.%m.%y") }.join(" – ")
    end

    def summary
      total_pages ? "прочитано #{pages_read} из #{total_pages} стр. (#{percent}%)" : "прочитано #{pages_read} стр."
    end
  end

  def initialize(reading)
    @reading = reading
    @total_pages = reading.total_pages
  end

  # Old attempts first, the current one is the last
  def bars
    @bars ||= begin
      by_attempt = @reading.progresses.group_by(&:attempt)
      current = by_attempt.keys.max
      by_attempt.sort.map { |attempt, entries| bar(attempt, entries, current: attempt == current) }
    end
  end

  def multiple_attempts?
    bars.size > 1
  end

  private

  def bar(attempt, entries, current:)
    # Later entries go later in the markup, so they are drawn on top
    entries = entries.sort_by { [it.date, it.created_at, it.id] }
    colors = day_colors(entries.map(&:date).uniq)

    Bar.new(
      attempt: attempt,
      current: current,
      first_date: entries.first.date,
      last_date: entries.last.date,
      pages_read: pages_read(entries),
      total_pages: @total_pages,
      segments: @total_pages ? entries.filter_map { segment(it, colors[it.date]) } : []
    )
  end

  def day_colors(dates)
    previous = nil
    dates.to_h do |date|
      choices = (0...PALETTE_SIZE).to_a - [previous]
      previous = choices[Random.new((@reading.id * 1_000_003) + date.jd).rand(choices.size)]
      [date, previous]
    end
  end

  # Length of the union of the entries' ranges: re-read pages are counted once
  def pages_read(entries)
    ranges = entries.map { [it.from_page, cut(it.to_page)] }.select { |from, to| to > from }.sort

    merged = ranges.each_with_object([]) do |(from, to), result|
      if result.any? && from <= result.last[1]
        result.last[1] = [result.last[1], to].max
      else
        result << [from, to]
      end
    end

    merged.sum { |from, to| to - from }
  end

  def segment(entry, color)
    from = cut(entry.from_page)
    to = cut(entry.to_page)
    return if to <= from

    Segment.new(left: percent_of(from), width: percent_of(to - from), color: color, hint: hint(entry))
  end

  def cut(page)
    @total_pages ? [page, @total_pages].min : page
  end

  def percent_of(pages)
    (pages * 100.0 / @total_pages).round(3)
  end

  def hint(entry)
    pages = entry.to_page - entry.from_page
    head = "#{entry.date.strftime("%d.%m.%y")} · с #{entry.from_page} по #{entry.to_page} · #{pages} стр."
    [head, entry.note].compact.join("\n")
  end
end
