class PagesImporterJob < ApplicationJob
  queue_as :pages

  after_perform do |job|
    self.class.set(wait: 60.minutes).perform_later(job.arguments)
  end

  def perform(term)
    pages_data = FBPageSearcher.new(term: term, token: token).call

    pages_data.each do |data|
      unless FacebookPage.exists?(facebook_id: data["id"])
        FacebookPage.create!(facebook_id: data["id"], name: data["name"])
      end
    end
  end

  private

  def token
    Rails.configuration.counterfind["facebook"]["tokens"].sample
  end
end
