# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/books', type: :request do
  before { login_user(user, password, sessions_path) }

  let!(:user) { create :user, password: password }
  let!(:password) { '12345678' }

  describe 'POST /create' do
    subject(:send_request) { post user_books_path(user), params: { book: book_params } }

    let(:book_params) do
      {
        title:  'Green Book',
        author: 'Alexander Green',
        short: 'false',
        compilation: 'false'
      }
    end

    it_behaves_like 'authentication needed action'
  end

  # update book
  # delete book
end
