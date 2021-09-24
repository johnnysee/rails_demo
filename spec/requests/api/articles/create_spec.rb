RSpec.describe 'POST /api/articles' do
  subject { response }

  describe 'when user is authenticated' do
    let(:user) { create(:user) }
    let(:credentials) { user.create_new_auth_token }
    before do
      post '/api/articles',
           params: { article: { title: 'My fantastic title', lede: 'Lorem ipsom....', author: 'Fraser' } }, headers: credentials
    end

    it { is_expected.to have_http_status 201 }

    it 'is expected to create a new article in the db' do
      article = Article.last
      expect(article).to_not eq nil
    end
  end

  describe 'when user is not authenticated' do
    before do
      post '/api/articles',
           params: {
             article: {
               title: 'My fantastic title',
               lede: 'Lorem ipsom....',
               author: 'Fraser'
             }
           }
    end

    it { is_expected.to have_http_status 401 }

    it 'is expected to reject the request' do
      expect(response_json['errors']).to include 'You need to sign in or sign up before continuing.'
    end
  end
end