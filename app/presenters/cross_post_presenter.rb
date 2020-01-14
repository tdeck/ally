class CrossPostPresenter < SimpleDelegator
  def initialize(xpost, meetup_client)
    @xpost = xpost
    @meetup_client = meetup_client

    super(xpost)
  end

  def status
     @status ||= @meetup_client.get_event(@xpost.dest_meetup, @xpost.dest_id)[:status].to_sym
  rescue RestClient::Gone
    :deleted
  rescue
    :unknown
  end

  def is_draft?
    status == :draft
  end

  def is_deleted?
    status == :deleted
  end
end
