class MigrateFacebookPageBrandsRelations < ActiveRecord::Migration[5.0]
  def change
    rename_column :facebook_pages, :brand_ids, :old_brand_ids

    say_with_time "migrating facebook pages brands" do
      FacebookPage.find_each do |page|
        page.brand_ids = page.old_brand_ids
        page.save!
      end
    end
  end
end
