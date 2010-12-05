class TimecardsController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => [:create]

  # GET /timecards
  # GET /timecards.xml
  def index
    @timecards = Timecard.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @timecards }
    end
  end

  # GET /timecards/1
  # GET /timecards/1.xml
  def show
    @timecard = Timecard.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @timecard }
    end
  end

  # GET /timecards/new
  # GET /timecards/new.xml
  def new
    if params[:via] == "email"
      if UserMailer.timecard_email(current_user).deliver
        redirect_to(:root, :notice => 'Timecard successfully sent')
      else
        redirect_to(:root, :notice => "Timecard was not sent")
      end
    else
      @timecard = Timecard.new
      @timecard.cardtext = current_user.defaulttimecard
    
      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @timecard }
      end
    end
  end

  # GET /timecards/1/edit
  def edit
    @timecard = Timecard.find(params[:id])
  end

  # POST /timecards
  # POST /timecards.xml
  def create
    
    if params[:via] == "email"
      input = params[:plain]
      input.gsub!(/> /, '')
      input = input.split(/---.*\n-.*\n/)[1]
      input = "---\n-\n" + input
      input.gsub!(/\n\*\*/, "\n    ")
      input.gsub!(/\n\*/, "\n  ")
               
      user = User.find_by_email(params[:from])
      @timecard = Timecard.new(:user_id => user.id, :cardtext => input, :workdate => DateTime.now)
      
      if @timecard.save
        logger.info "Emailed timecard was successfully saved."
        redirect_to (:root)
      else
        logger.info "Emailed timecard was not saved"
        redirect_to (:root)
      end
    else
      @timecard = Timecard.new(params[:timecard])

      @timecard.user_id = current_user.id

      respond_to do |format|
        if @timecard.save
          format.html { redirect_to(@timecard, :notice => 'Timecard was successfully created.') }
          format.xml  { render :xml => @timecard, :status => :created, :location => @timecard }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @timecard.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /timecards/1
  # PUT /timecards/1.xml
  def update
    @timecard = Timecard.find(params[:id])

    respond_to do |format|
      if @timecard.update_attributes(params[:timecard])
        format.html { redirect_to(@timecard, :notice => 'Timecard was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @timecard.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /timecards/1
  # DELETE /timecards/1.xml
  def destroy
    @timecard = Timecard.find(params[:id])
    @timecard.destroy

    respond_to do |format|
      format.html { redirect_to(timecards_url) }
      format.xml  { head :ok }
    end
  end
end
