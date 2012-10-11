require 'spec_helper'

describe MapsController do
  describe "GET classes" do
    describe "assigns days correctly:" do
      before(:each) do
        Venue.stub(:all_with_classes_listed_on_day)
        Venue.stub(:all_with_classes_listed)
      end
      it "@day should be nil if the url contained no date part" do
        get :classes
        assigns[:day].should be_nil
      end

      it "@day should be a capitalised string if the url contained a day name" do
        get :classes, day: "tuesday"
        assigns[:day].should == "Tuesday"
      end
      it "should raise a 404 if the url contained a string which was a day name" do
        expect { get :classes, day: "fuseday" }.to raise_error(ActiveRecord::RecordNotFound)
      end
      context "when the day is described in words" do
        before(:each) do
          controller.stub(:today).and_return(Date.new(2012,10,11)) # A thursday
        end
        it "@day should be today's day name (capitalised) if the url contained 'today'" do
          get :classes, day: "today"
          assigns[:day].should == "Thursday"
        end
        it "@day should be tomorrow's day name (capitalised) if the url contained 'tomorrow'" do
          get :classes, day: "tomorrow"
          assigns[:day].should == "Friday"
        end
        it "should raise a 404 if the url contained 'yesterday'" do
          expect { get :classes, day: "yesterday" }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end 
    # it "assigns @teams" do
    #   team = Team.create
    #   get :index
    #   assigns(:teams).should eq([team])
    # end
    # 
    # it "renders the index template" do
    #   get :index
    #   response.should render_template("index")
    # end
  end
  
  describe "GET socials" do
    describe "assigns dates correctly:" do
      before(:each) do
        Event.stub(:socials_on_date).and_return([])
        Event.stub(:socials_dates).and_return([])
      end
      it "@date should be nil if the url contained no date" do
        get :socials
        assigns[:day].should be_nil
      end
      context "when the url contains a string representing a date" do
        before(:each) do
          @date_string = "2012-12-23"
          @date = Date.new(2012,12,23)
        end
        it "@date should be a date if that date is in the listing dates" do
          Event.stub(:listing_dates).and_return([@date])
          get :socials, date: @date_string 
          assigns[:date].should == @date
        end
        it "should raise a 404 if the date is not in the listing dates" do
          Event.stub(:listing_dates).and_return([])
          expect { get :socials, date: @date_string }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end    
      context "when the url contains a date described in words" do
        before(:each) do
          @date = Date.today
          controller.stub(:today).and_return(@date)
        end
        it "@date should be today's date if the description is 'today'" do
          get :socials, date: "today"
          assigns[:date].should == @date
        end
        it "@date should be tomorrow's date if the description is 'tomorrow'" do
          get :socials, date: "tomorrow"
          assigns[:date].should == @date + 1
        end
        it "should raise a 404 if the description is 'yesterday'" do
          expect { get :socials, date: "yesterday" }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
      it "should raise a 404 if the url contains as string which doesn't represent a date" do
        expect { get :socials, date: "asfasfasf" }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

end