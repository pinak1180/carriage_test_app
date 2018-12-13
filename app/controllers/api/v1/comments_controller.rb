class Api::V1::CommentsController < Api::V1::BaseController
  before_action :authenticate_user_with_authentication_token
  before_action :set_commentable_resource

  def create
    comment = @commentable.comments.build(user_id: @current_user.id, content: params[:comment][:content])
    if comment.save
      render_json_object(object: comment)
    else
      render_json_object_error(object: comment)
    end
  end

  def update
    comment = @commentable.comments.find(params[:id])
    bad_record unless comment.present?
    if comment.update(content: params[:comment][:content])
      render_json_object(object: comment)
    else
      render_json_object_error(object: comment)
    end
  end

  def destroy
    comment = @commentable.comments.find(params[:id])
    bad_record unless comment.present?
    if comment.user_id.eql?(@current_user.id) || @current_user.admin?
      if comment.destroy
        render_json_message('Comment Deleted Successfully')
      end
    else
      render_json_message('Comment can only be deleted by owner/admin')
    end
  end

  def index
    comments = @commentable.comments.page(@page).per(@limit)
    render_json_object(object: comments)
  end

  def show
    comment = @commentable.comments.find(params[:id])
    render_json_object(object: comment)
  end

  def set_commentable_resource
    @resource_type = params[:comment][:resource_type] || params[:resource_type]
    if @resource_type.eql?('card') || @resource_type.eql?('comment')
      @commentable = @resource_type.titlecase.constantize.find(params[:comment][:resource_id] || params[:resource_id])
      bad_record unless @commentable.present?
    else
      render_json_message("Invalid resource_type '#{@resource_type}' can be either 'card' or 'comment'")
    end
  end
end
