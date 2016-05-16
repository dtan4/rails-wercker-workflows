require "spec_helper"

feature "News releases" do
  context "as a user" do
    scenario "adds a news release" do
      user = create(:user)
      sign_in(user)
      visit root_path
      click_link "News"

      expect(page).to_not have_content "BigCo switches to Rails"

      click_link "Add News Release"

      fill_in "Date", with: "2013-07-29"
      fill_in "Title", with: "BigCo switches to Rails"
      fill_in "Body", with: "BigCo has released a new website build with open source."
      click_button "Create News release"

      expect(current_path).to eq news_releases_path
      expect(page).to have_content "Successfully created news release."
      expect(page).to have_content "2013-07-29: BigCo switches to Rails"
    end
  end

  context "as a guest" do
    scenario "reads a new release" do
      create(:news_release,
             title: "Record profits for BigCo!",
             released_on: "2013-08-01",
             body: "Today, BigCo's CFO announced record growth.")

      visit root_path
      click_link "News"

      expect(page).to_not have_content "Today, BigCo's CFO announced record growth.'"
      expect(page).to_not have_content "Add News Release"

      click_link "2013-08-01: Record profits for BigCo!"

      expect(page).to have_content "Today, BigCo's CFO announced record growth."
    end
  end
end
