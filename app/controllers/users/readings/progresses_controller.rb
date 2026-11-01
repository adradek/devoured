# frozen_string_literal: true

module Users
  module Readings
    # Progress entries of a reading. The panel with recent entries and the form replaces
    # the reading card inside its turbo frame; after saving, the card comes back.
    #
    # See doc/features/reading-progress.md
    class ProgressesController < ApplicationController
      RECENT_ENTRIES_COUNT = 2

      before_action :set_user
      before_action :authorize_user
      before_action :set_reading

      def new
        @progress = ReadingProgress.new(from_page: @reading.last_progress&.to_page)
        set_panel_data
      end

      def create
        @progress = ReadingProgressCreation.run(@reading, progress_params, start_over: start_over?)

        if @progress.persisted?
          render partial: "users/books/reading", locals: { reading: ReadingDecorator.new(@reading) }
        else
          set_panel_data
          render :new, status: :unprocessable_content
        end
      end

      private

      def set_user
        @user = User.find_by(secret_id: params[:user_secret_id])
      end

      def authorize_user
        authorize @user, :update?
      end

      def set_reading
        @reading = @user.readings.includes(:book).find(params[:reading_id])
      end

      def set_panel_data
        @recent_progresses = @reading.progresses.order(attempt: :desc).latest_first.limit(RECENT_ENTRIES_COUNT)
        @can_start_over = @reading.last_progress.present?
      end

      def progress_params
        params.expect(reading_progress: [:date, :from_page, :to_page, :note])
      end

      def start_over?
        ActiveModel::Type::Boolean.new.cast(params[:start_over]) == true
      end
    end
  end
end
