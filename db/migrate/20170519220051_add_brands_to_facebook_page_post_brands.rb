class AddBrandsToFacebookPagePostBrands < ActiveRecord::Migration[5.0]
  def up
    populate_facebook_page_post_brands
    drop_table :post_brands
  end

  def down

  end


  private
    def populate_facebook_page_post_brands
      FacebookPost.unscoped.all.find_each do |post|
        if post.manual_added_brands.any?
          post.manual_added_brands.each do |brand|
            facebook_page_brand = post.facebook_page.facebook_page_brands.find_or_initialize_by(brand_id: brand.id)
            facebook_page_brand.facebook_page_post_brands.new(facebook_post: post)
            facebook_page_brand.save
            puts "Manual Brand Added for post: #{post.id} against brand: #{brand.id}"
          end
        else
          post.facebook_page.facebook_page_brands.find_each do |page_brand|
            page_brand.facebook_page_post_brands.create(facebook_post: post)
            puts "post: #{post.id} against page_brand: #{page_brand.id}"
          end
        end
      end
    end
end
