class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_mailbox
  before_action :get_box, only: [:index, :show]
  before_action :get_conversation, except: [:index, :empty_trash]
 
  def index
    if @box.eql? "inbox"
      @conversations = @mailbox.inbox
    elsif @box.eql? "sent"
      @conversations = @mailbox.sentbox
    else
      @conversations = @mailbox.trash
    end
    @conversations = @conversations.page(params[:page]).per(10)
  end

  def show
    @conversation.mark_as_read(current_user)
  end
  
  def reply
    current_user.reply_to_conversation(@conversation, params[:body])
    user_to_reply = @conversation.participants.reject { |u| u.id == current_user.id }.last
    UserMailer.notify_user(user_to_reply).deliver
    # NotificationEmail.perform_async(user_to_reply.id)
    flash[:success] = 'Reply sent'
    redirect_to conversation_path(@conversation)
  end
  
  def destroy
    @conversation.move_to_trash(current_user)
    flash[:success] = 'The conversation was moved to trash.'
    redirect_to conversations_path(box: params[:box])
  end
 
  def restore
    @conversation.untrash(current_user)
    flash[:success] = 'The conversation was restored.'
    redirect_to conversations_path(box: 'trash')
  end
  
  def empty_trash
    @mailbox.trash.each do |conversation|
      conversation.receipts_for(current_user).update_all(deleted: true)
    end
    flash[:success] = 'Your trash was cleaned!'
    redirect_to conversations_path
  end
 
  private

  def get_mailbox
    @mailbox ||= current_user.mailbox
  end

  def get_conversation
    @conversation ||= @mailbox.conversations.find(params[:id])
  end
  
  def get_box
    if params[:box].blank? or !["inbox","sent","trash"].include?(params[:box])
      params[:box] = 'inbox'
    end
    @box = params[:box]
  end
end