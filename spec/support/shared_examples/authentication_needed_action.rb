# frozen_string_literal: true

shared_examples_for 'authentication needed action' do
  context 'when user not logged in' do
    before do
      logout_request
    end

    it 'redirects to login page' do
      send_request
      expect(response).to redirect_to(login_url)
    end
  end
end
