class AddPostLinkToCrossPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :cross_posts, :post_link, :string
  end
end
