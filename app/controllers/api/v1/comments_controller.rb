class Api::V1::CommentsController < Api::V1::BaseController
  before_action :authenticate_user_with_authentication_token
  before_action :set_commentable_resource
  before_action :set_comment, :set_comment_policy, except: [:create, :index]

  def create
    comment = @commentable.comments.build(user_id: @current_user.id, content: params[:comment][:content])
    render_json_un_authorization unless CommentAccessManager.new(object: comment, user: @current_user).create?
    if comment.save
      render_json_object(object: comment)
    else
      render_json_object_error(object: comment)
    end
  end

  def update
    render_json_un_authorization unless @comment_policy.update?
    bad_record unless comment.present?
    if @comment.update(content: params[:comment][:content])
      render_json_object(object: @comment)
    else
      render_json_object_error(object: @comment)
    end
  end

  def destroy
    render_json_un_authorization unless @comment_policy.delete?
    if @comment.destroy
      render_json_message('Comment Deleted Successfully')
    else
      render_json_message('Comment cannot be Deleted please try again later.')
    end
  end

  def index
    comments = CommentAccessManager.new(object: @comment, user: @current_user).access_scope
    render_json_object(object: comments.page(@page).per(@limit))
  end

  def show
    render_json_object(object: @comment)
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

  def set_comment
    @comment = @commentable.comments.find(params[:id])
  end

  def set_comment_policy
    @comment_policy = CommentAccessManager.new(object: @comment, user: @current_user)
  end
end
