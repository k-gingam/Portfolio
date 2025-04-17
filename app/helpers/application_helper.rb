module ApplicationHelper
  def default_meta_tags
    {
      site: "Omoro",
      title: "面白いと思ったゲーム動画の共有に特化したサイト",
      charset: "utf-8",
      description: "Omoroでは、面白いと思ったゲーム動画を共有することができます。自分の好きなゲーム動画を見つけて、他の人と共有しましょう！",
      keywords: "ゲーム,動画,共有",
      canonical: "https://omoro-play.com/",
      separator: "|",
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: "website",
        url: "https://omoro-play.com/",
        image: image_url("Omoro_logo.png"),
        locale: "ja-JP"
      },
      twitter: {
        card: "summary_large_image",
        image: image_url("Omoro_logo.png")
      }
    }
  end
end
