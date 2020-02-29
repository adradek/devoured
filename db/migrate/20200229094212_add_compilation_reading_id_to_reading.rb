class AddCompilationReadingIdToReading < ActiveRecord::Migration[5.0]
  def change
    add_reference :readings, :compilation_reading
  end
end
