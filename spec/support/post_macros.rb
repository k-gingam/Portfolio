module PostMacros
  def post_create
    visit new_post_path
    fill_in '動画URL', with: "https://www.youtube.com/live/0dUzNxlovRs?si=uXpDlGOmlaM6H62G"
    fill_in 'コメント', with: 'コメントテスト'
    fill_in 'タグ', with: 'タグテスト1,タグテスト2'
    find('input.btn-primary.post-btn').click

    # click_on '選択'
    # fill_in "word", with: "sdjafiejalif"
    # find('input.btn-primary.search-btn').click
    # expect(page).to have_content "ゲームが見つかりませんでした。"
  end
end
