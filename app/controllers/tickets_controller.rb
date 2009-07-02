require 'vendor/plugins/lighthouse-api/lib/lighthouse-api'
require 'lighthouse_api_extensions'
# require 'vendor/plugins/cache_fu/init'
# require 'vendor/plugins/cached_resource/init'

Lighthouse.account = 'animoto'
Lighthouse.authenticate('stevie@animoto.com', 'yourbull1')
ActiveResource::Base.logger = ActiveRecord::Base.logger

class TicketsController < ApplicationController
  # GET /tickets
  # GET /tickets.xml
  def index
    pp = Lighthouse::Project.find(:all)
    
    # SUPER HACKY way to speed up the multiple bin grabs
    # each bin should do it's own ajax call to the tickets endpoint with 
    # specific search parameters
    threads = []
    threads << Thread.new{ @jeff_tickets = pp[12].tickets(:q => 'responsible:jeff state:open milestone:"after hack" sort:priority') }
    threads << Thread.new{ @jordan_tickets = pp[12].tickets(:q => 'responsible:jordan state:open milestone:"after hack" sort:priority') }
    threads << Thread.new{ @moses_tickets = pp[12].tickets(:q => 'responsible:moses state:open milestone:"after hack" sort:priority') }
    threads << Thread.new { @chris_tickets = pp[12].tickets(:q => 'responsible:chris state:open milestone:"after hack" sort:priority') }
    threads << Thread.new { @unassigned_tickets = pp[12].tickets(:q => 'responsible:none state:open milestone:"after hack" sort:priority') }
    threads.each{|t| t.join }
    
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tickets }
    end
  end

  # GET /tickets/1
  # GET /tickets/1.xml
  def show
    @ticket = Ticket.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ticket }
    end
  end

  # GET /tickets/new
  # GET /tickets/new.xml
  def new
    @ticket = Ticket.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ticket }
    end
  end

  # GET /tickets/1/edit
  def edit
    @ticket = Ticket.find(params[:id])
  end

  # POST /tickets
  # POST /tickets.xml
  def create
    @ticket = Ticket.new(params[:ticket])

    respond_to do |format|
      if @ticket.save
        flash[:notice] = 'Ticket was successfully created.'
        format.html { redirect_to(@ticket) }
        format.xml  { render :xml => @ticket, :status => :created, :location => @ticket }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ticket.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tickets/1
  # PUT /tickets/1.xml
  def update
    logger.info { "PARAMS: #{params.inspect}" }
    project_id, id = params[:id].split('-')
    ticket = Lighthouse::Ticket.find(id, :params => {:project_id => project_id})
    
    # insanely hacky.  can't nest json, so don't want to do a willy-nilly merge.
    # move mergeable params to the [:ticket] hash to follow usual rails conventions
    # before merging
    params[:ticket] = {}
    %w(assigned_user_id state milestone_id).each do |field|
      params[:ticket].merge!( field => params.delete(field) ) if params[field]
    end
    logger.info { "TICKET ATTRS TO UPDATE: #{params[:ticket].inspect}"}
    
    ticket.attributes.merge!( params[:ticket] )
    ticket.save

    respond_to do |format|
      # if @ticket.update_attributes(params[:ticket])
      #   flash[:notice] = 'Ticket was successfully updated.'
      #   format.html { redirect_to(@ticket) }
      #   format.xml  { head :ok }
      # else
      #   format.html { render :action => "edit" }
      #   format.xml  { render :xml => @ticket.errors, :status => :unprocessable_entity }
      # end
    end
  end

  # DELETE /tickets/1
  # DELETE /tickets/1.xml
  def destroy
    @ticket = Ticket.find(params[:id])
    @ticket.destroy

    respond_to do |format|
      format.html { redirect_to(tickets_url) }
      format.xml  { head :ok }
    end
  end
  
  # http://stackoverflow.com/questions/411746/rubyonrails-2-2-jquery-ui-sortable-ajax-this-is-how-i-did-it-is-their-a-bett
  # def sort
  #   load_lesson
  #   part_positions = params[:part].to_a
  #   @parts.each_with_index do |part, i|
  #     part.position = part_positions.index(part.id.to_s) + 1
  #     part.save
  #   end
  #   render :text => 'ok'
  # end
end
