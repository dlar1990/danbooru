require 'test_helper'

module Downloads
  class ArtStationTest < ActiveSupport::TestCase
    context "a download for a (small) artstation image" do
      setup do
        @asset = "https://cdnb3.artstation.com/p/assets/images/images/003/716/071/small/aoi-ogata-hate-city.jpg?1476754974"
        @download = Downloads::File.new(@asset)
      end

      should "download the /4k/ image instead" do
        file, strategy = @download.download!
        assert_equal(1_880_910, ::File.size(file.path))
      end
    end

    context "for an image where an original does not exist" do
      setup do
        @asset = "https://cdna.artstation.com/p/assets/images/images/004/730/278/large/mendel-oh-dragonll.jpg"
        @download = Downloads::File.new(@asset)
      end

      should "not try to download the original" do
        file, strategy = @download.download!
        assert_equal(483_192, ::File.size(file.path))
      end
    end

    context "a download for an ArtStation image hosted on CloudFlare" do
      setup do
        @asset = "https://cdnb.artstation.com/p/assets/images/images/003/716/071/large/aoi-ogata-hate-city.jpg?1476754974"
      end

      should "return the original file, not the polished file" do
        assert_downloaded(1_880_910, @asset)
      end

      should "return the original filesize, not the polished filesize" do
        assert_equal(1_880_910, Downloads::File.new(@asset).size)
      end
    end

    context "a download for a https://$artist.artstation.com/projects/$id page" do
      setup do
        @source = "https://dantewontdie.artstation.com/projects/YZK5q"
        @download = Downloads::File.new(@source)
      end

      should "download the original image instead" do
        file, strategy = @download.download!

        assert_equal(247_350, ::File.size(file.path))
      end
    end
  end
end
