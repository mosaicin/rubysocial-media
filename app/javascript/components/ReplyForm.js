import React from "react"
import CommentForm from './CommentForm'

class ReplyForm extends CommentForm {
  render () {
    return (
        <form onSubmit={this.handleSubmit}>
          <div className="form-group">
            <textarea className="form-control" rows="3" name="body" value={this.state.body} onChange={this.handleBodyChange}></textarea>
          </div>
          <div className="form-group">
            <label htmlFor="reply-media">Фото, видео или аудио</label>
            <input id="reply-media" ref={(input) => { this.fileInput = input; }} type="file" multiple accept="image/*,video/*,audio/*" onChange={this.handleMediaChange} className="form-control-file" />
            <small className="form-text text-muted">До 10 файлов. Изображения до 15 МБ, аудио до 100 МБ, видео до 250 МБ.</small>
          </div>
          <input type="hidden" value={this.props.csrf_token} />
          <button type="submit" className="btn btn-primary">Отправить</button>
        </form>
    );
  }
}

export default ReplyForm
