# frozen_string_literal: true

shared_examples_for "authorization protected action" do
  context "when user not authorized to perform action" do
    before do
      logout_request
      login_user(create(:user, password: "abcdefgh"), "abcdefgh", sessions_path)
    end

    it "responds with 403 status" do
      send_request
      expect(response.status).to eq(403)
    end
  end
end
