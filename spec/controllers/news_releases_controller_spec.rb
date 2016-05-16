require 'spec_helper'

describe NewsReleasesController, type: :controller do
  shared_examples "full access to news_releases" do
    describe "POST #create" do
      context "with valid attributes" do
        it "creates the news_release" do
          expect do
            post :create, news_release: attributes_for(:news_release)
          end.to change(NewsRelease, :count).by(1)
        end

        it "redirects to news_release#show" do
          post :create, news_release: attributes_for(:news_release)
          expect(response).to redirect_to news_releases_url
        end
      end

      context "with invalid attributes" do
        it "does not create the news_release" do
          expect do
            post :create, news_release: attributes_for(:invalid_news_release)
          end.not_to change(NewsRelease, :count)
        end

        it "re-renders the :new template" do
          post :create, news_release: attributes_for(:invalid_news_release)
          expect(response).to render_template :new
        end
      end
    end

    describe "PATCH #update" do
      let(:news_release) do
        create(:news_release,
               title: "news title",
               body: "samplesample")
      end

      context "with valid attributes" do
        it "updates the contact" do
          patch :update, id: news_release, news_release: attributes_for(:news_release,
                                                                        title: "title news",
                                                                        body: "hogefuga")
          news_release.reload
          expect(news_release.title).to eq "title news"
          expect(news_release.body).to eq "hogefuga"
        end

        it "redirects to the updated contact" do
          patch :update, id: news_release, news_release: attributes_for(:news_release)
          expect(response).to redirect_to news_release
        end
      end

      context "with invalid attributes" do
        it "dows not change the news_release's attributes" do
          patch :update, id: news_release, news_release: attributes_for(:invalid_news_release)
          news_release.reload
          expect(news_release.title).to eq "news title"
          expect(news_release.body).to eq "samplesample"
        end

        it "re-renders to the :edit template" do
          patch :update, id: news_release, news_release: attributes_for(:invalid_news_release)
          expect(response).to render_template :edit
        end
      end
    end

    describe "DELETE #destroy" do
      let!(:news_release) do
        create(:news_release)
      end

      it "deletes the news_release from the database" do
        expect do
          delete :destroy, id: news_release
        end.to change(NewsRelease, :count).by(-1)
      end

      it "redirects to news_releases#index" do
        delete :destroy, id: news_release
        expect(response).to redirect_to news_releases_url
      end
    end
  end

  describe "user access" do
    before do
      set_user_session(create(:user))
    end

    it_behaves_like "full access to news_releases"
  end

  describe "guest access" do
    describe "GET #new" do
      it "requires login" do
        get :new
        expect(response).to require_login
      end
    end

    describe "POST #create" do
      it "requires login" do
        post :create, news_release: attributes_for(:news_release)
        expect(response).to require_login
      end
    end

    describe "PATCH #update" do
      it "requires login" do
        news_release = create(:news_release)
        patch :update, id: news_release, news_release: attributes_for(:news_release,
                                                                      title: "title",
                                                                      body: "body")
        expect(response).to require_login
      end
    end

    describe "DELETE #destroy" do
      it "requires login" do
        news_release = create(:news_release)
        delete :destroy, id: news_release
        expect(response).to require_login
      end
    end
  end
end
