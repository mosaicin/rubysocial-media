import React from "react"
import Comments from './Comments';
import CommentForm from './CommentForm';

class CommentsApp extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      comments: props.comments,
      replies: props.replies
    };

    this.handleSubmitComment = this.handleSubmitComment.bind(this);
  }

  render () {
    return (
      <div>
       <div id="comment_error"></div>
       <CommentForm csrf_token={this.props.csrf_token} onSubmit={this.handleSubmitComment} />
       <Comments comments={this.state.comments} post_id={this.props.post_id} replies={this.state.replies} csrf_token={this.props.csrf_token} />
      </div>
    );
  }

  handleSubmitComment(comment) {
    const formData = new FormData();
    formData.append('body', comment.body || '');
    formData.append('post_id', this.props.post_id);
    (comment.media || []).forEach((file) => formData.append('media[]', file));

    $.ajax({
      url: "/comments/create/" + this.props.post_id,
      dataType: 'json',
      type: 'POST',
      data: formData,
      processData: false,
      contentType: false,
      headers: {'X-CSRF-Token': this.props.csrf_token},
      success: function(data) {
        $('div#comment_error').html('');
        if (data.errors != null && !jQuery.isEmptyObject(data.errors)) {
          const messages = Object.keys(data.errors).reduce((all, key) => all.concat(data.errors[key]), []);
          messages.forEach((error) => $('div#comment_error').append('<div class="alert alert-danger" role="alert">' + error + '</div>'));
        } else {
          $('div#comment_error').html('<div class="alert alert-success" role="alert">Комментарий добавлен</div>');
          this.setState({comments: this.state.comments.concat([data.comment])});
        }
      }.bind(this),
      error: function(xhr, status, err) {
        console.error('/comments/create/' + this.props.post_id, status, err.toString());
      }.bind(this)
    });
  }
}

export default CommentsApp
