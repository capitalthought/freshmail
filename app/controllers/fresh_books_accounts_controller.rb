class FreshBooksAccountsController < ApplicationController
  # GET /fresh_books_accounts
  # GET /fresh_books_accounts.xml
  def index
    @fresh_books_accounts = FreshBooksAccount.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @fresh_books_accounts }
    end
  end

  # GET /fresh_books_accounts/1
  # GET /fresh_books_accounts/1.xml
  def show
    @fresh_books_account = FreshBooksAccount.find(current_user.fresh_books_account)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @fresh_books_account }
    end
  end

  # GET /fresh_books_accounts/new
  # GET /fresh_books_accounts/new.xml
  def new
    @fresh_books_account = FreshBooksAccount.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @fresh_books_account }
    end
  end

  # GET /fresh_books_accounts/1/edit
  def edit
    @fresh_books_account = FreshBooksAccount.find(params[:id])
  end

  # POST /fresh_books_accounts
  # POST /fresh_books_accounts.xml
  def create
    @fresh_books_account = FreshBooksAccount.new(params[:fresh_books_account])

    respond_to do |format|
      if @fresh_books_account.save
        format.html { redirect_to(:root, :notice => 'Fresh books account was successfully created.') }
        format.xml  { render :xml => @fresh_books_account, :status => :created, :location => @fresh_books_account }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @fresh_books_account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /fresh_books_accounts/1
  # PUT /fresh_books_accounts/1.xml
  def update
    @fresh_books_account = FreshBooksAccount.find(params[:id])

    respond_to do |format|
      if @fresh_books_account.update_attributes(params[:fresh_books_account])
        format.html { redirect_to(:root, :notice => 'Fresh books account was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @fresh_books_account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /fresh_books_accounts/1
  # DELETE /fresh_books_accounts/1.xml
  def destroy
    @fresh_books_account = FreshBooksAccount.find(params[:id])
    @fresh_books_account.destroy

    respond_to do |format|
      format.html { redirect_to(fresh_books_accounts_url) }
      format.xml  { head :ok }
    end
  end
end
