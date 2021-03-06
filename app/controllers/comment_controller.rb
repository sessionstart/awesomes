class CommentController < ApplicationController
	before_action :mem_login
  before_action :comment_lost,:except=> ['save']

  def comment_lost
    @item = Comment.find(params[:id])
    render json: {status: false} and return if @item.mem != current_mem
  end
  
	def save
		if (_id = params[:id]) and (_item = Comment.find_by_id(_id))
      comment_lost
      _item.update_attributes({:con=> params[:con]})
    else
      _item = Comment.create({:typ=> params[:typ],:idcd=> params[:idcd],:con=> params[:con],:mem_id=> current_mem.id})
      _item.target.update_comment
    end
    render json: {status: true,url: _item.target_url} 
	end

  def destroy 
    @item.destroy
    render json: {status: true}
  end

  def edit
    @comment = {:typ=> @item.typ,:idcd=> @item.idcd,:id=> @item.id}
  end

end
