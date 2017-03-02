require 'rails_helper'

RSpec.describe FbURLParser do
  subject { FbURLParser }
  let(:page_url) { "https://www.facebook.com/dallas.cowboys.fanprint/" }
  let(:page_url2) { "https://www.facebook.com/dallas.cowboys.fanprint?params" }
  let(:post_url) { "https://www.facebook.com/dallas.cowboys.fanprint/posts/1473078859383568/" }
  let(:post_url2) { "https://www.facebook.com/permalink.php?story_fbid=419027201779061&id=408307019517746" }
  let(:post_url3) { "https://www.facebook.com/NEPatriotsGear/posts/652545598258367:0" }
  let(:photo_url) { "https://www.facebook.com/dallas.cowboys.fanprint/photos/a.1422014691156652.1073741828.1422004941157627/1485364868154967/?type=3&theater" }
  let(:photo_url2) { "https://www.facebook.com/photo.php?fbid=1466717743347171&set=o.499785186724407&type=3&theater" }
  let(:video_url) { "https://www.facebook.com/dallas.cowboys.fanprint/videos/1482310061793781/" }
  let(:group_post_url) { "https://www.facebook.com/groups/1699988863566929/permalink/1903057716593375/" }

  it "raise ArgumentError with missing arguments" do
    expect{subject.new}.to raise_error(ArgumentError)
    expect{subject.new(page_url)}.to_not raise_error
  end

  it "can extract a page id from url" do
    expect(subject.new(page_url).call).to eq(["dallas.cowboys.fanprint", :page])
    expect(subject.new(page_url2).call).to eq(["dallas.cowboys.fanprint", :page])
  end

  it "can extract a post id from url" do
    expect(subject.new(post_url).call).to eq(["1473078859383568", :post])
    expect(subject.new(post_url2).call).to eq(["419027201779061", :post])
    expect(subject.new(post_url3).call).to eq(["652545598258367", :post])
  end

  it "can extract an photo id from url" do
    expect(subject.new(photo_url).call).to eq(["1485364868154967", :photo])
    expect(subject.new(photo_url2).call).to eq(["1466717743347171", :photo])
  end

  it "can extract a video id from url" do
    expect(subject.new(video_url).call).to eq(["1482310061793781", :video])
  end

  it "can extract a video id from group post url" do
    expect(subject.new(group_post_url).call).to eq(["1903057716593375", :post])
  end

end
