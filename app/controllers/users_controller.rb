class UsersController < ApplicationController
  skip_before_filter :require_login, :only => [:new, :create, :login]

  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  def login
    if current_facebook_user
      current_facebook_user.fetch
      if current_facebook_user.email
        @user_session = UserSession.new(current_facebook_user)
        if @user_session.save
          flash[:notice] = "Login successful!"
          redirect_back_or_default(@user_session.user)
          return
        end
      end
    end
    redirect_back_or_default(current_user) if logged_in?
    
    if !params[:user_session].nil? then
      @user_session = UserSession.new(params[:user_session])
      if @user_session.save
        flash[:notice] = "Login successful!"
        redirect_back_or_default(@user_session.user)
      end
    else
      @user_session = UserSession.new
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create

    params[:user].reject! {|k,v| !['name','email','password','facebook_uid'].include?k }
    @user = User.new(params[:user])
    if @user.facebook_uid and current_facebook_user and current_facebook_client
      if current_facebook_user.id == @user.facebook_uid
        @user.facebook_session_key = current_facebook_client.access_token
        @user.password = "fb-#{@user.facebook_uid}-"+Time.now().to_s if @user.password.empty?
      end
    else
      if @user.password != params[:password_verify] then
        @user.errors.add(:password, "Password fields don't match")
        respond_to do |format|
          format.html { render :action => "new" }
          format.json { render json: @user }
        end
        return
      end
    end
    
    respond_to do |format|
      if @user.save
        UserSession.create(@user, true)
        format.html { redirect_to(@user, :notice => 'User was successfully created.') }
        format.json { render json: @user }
      else
        format.html { render :action => "new" }
        format.json { render json: @user }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    params[:user].reject! { |k,v|
      !['name','email','facebook_uid'].include?k || (k=='password' && v != '' && v == params[:password_verify])
    }
    @user = User.find(current_user.id)

    respond_to do |format|
      if params[:user]['facebook_uid'] and params[:user]['facebook_uid'] != ""
        params[:user].delete 'facebook_uid' if current_facebook_user.nil? or current_facebook_client.nil? or current_facebook_user.id != params[:user]['facebook_uid']
      end
      if @user.update_attributes(params[:user])
        if @user.facebook_uid and current_facebook_user and current_facebook_client
          if current_facebook_user.id == @user.facebook_uid
            @user.facebook_session_key = current_facebook_client.access_token
          end
        end
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
end
