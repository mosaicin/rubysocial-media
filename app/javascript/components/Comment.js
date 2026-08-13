import React from "react"
import Replies from './Replies';
import ReplyForm from './ReplyForm';
import MediaAttachments from './MediaAttachments';

class Comment extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      replyFormShow: false,
      replies: this.props.replies || []
    }

    this.showHideReplyForm = this.showHideReplyForm.bind(this)
    this.handleSubmitReply = this.handleSubmitReply.bind(this)
  }

  showHideReplyForm(e) {
    e.preventDefault();
    this.setState({replyFormShow: !this.state.replyFormShow});
  }

  handleSubmitReply(reply) {
    const formData = new FormData();
    formData.append('body', reply.body || '');
    formData.append('post_id', this.props.post_id);
    formData.append('parent_id', this.props.comment.id);
    (reply.media || []).forEach((file) => formData.append('media[]', file));

    $.ajax({
      url: "/comments/create/" + this.props.post_id + '/replies/' + this.props.comment.id,
      dataType: 'json',
      type: 'POST',
      data: formData,
      processData: false,
      contentType: false,
      headers: {'X-CSRF-Token': this.props.csrf_token},
      success: function(data) {
        $('div#reply_error_' + this.props.comment.id).html('');
        if (data.errors != null && !jQuery.isEmptyObject(data.errors)) {
          const messages = Object.keys(data.errors).reduce((all, key) => all.concat(data.errors[key]), []);
          messages.forEach((error) => $('div#reply_error_' + this.props.comment.id).append('<div class="alert alert-danger" role="alert">' + error + '</div>'));
        } else {
          $('div#reply_error_' + this.props.comment.id).html('<div class="alert alert-success" role="alert">Комментарий добавлен</div>');
          this.setState({replies: this.state.replies.concat([data.comment])});
        }
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.post_id + '/replies/' + this.props.comment.id, status, err.toString());
      }.bind(this)
    });
  }

  render () {
    var repliesBox=''
    if (this.state.replies != null && 
      Array.isArray(this.state.replies) && 
      this.state.replies.length) {
        repliesBox = <Replies replies={this.state.replies} />
      } 

    return (
      <div className="media mb-4">
        <img className="d-flex mr-3 rounded-circle" src="http://placehold.it/50x50" alt="" />
        <div className="media-body">
          <h5 className="mt-0">Commenter Name</h5>
          <div>{this.props.comment.body}</div>
          <MediaAttachments media={this.props.comment.media} />
          {repliesBox}
          <div id={"reply_error_" + this.props.comment.id}></div>
          <a href="#" onClick={this.showHideReplyForm}>Ответить</a>
          { this.state.replyFormShow && <ReplyForm onSubmit={this.handleSubmitReply} csrf_token={this.props.csrf_token} /> }
        </div>
      </div>
    );
  }
}

export default Comment
