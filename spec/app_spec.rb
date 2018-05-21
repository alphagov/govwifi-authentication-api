RSpec.describe App do
  describe 'visiting /' do
    it 'responds with 200 to a GET' do
      get '/'
      expect(last_response).to be_ok
    end

    it 'responds with Hello in the body' do
      get '/'
      expect(last_response.body).to eq('Hello')
    end
  end
end
