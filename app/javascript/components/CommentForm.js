import React from "react"

class CommentForm extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      body: '',
      media: []
    }

    this.handleBodyChange = this.handleBodyChange.bind(this)
    this.handleMediaChange = this.handleMediaChange.bind(this)
    this.handleSubmit = this.handleSubmit.bind(this)
  }

  handleBodyChange(e) {
    const updatedValue = e.target.value
    this.setState(prevState => {
      return {
        body: updatedValue
      };
    });
  }

  handleMediaChange(e) {
    this.setState({media: Array.from(e.target.files || [])});
  }

  handleSubmit(e) {
    e.preventDefault();
    var body = this.state.body.trim();
    if (!body && !this.state.media.length) {
      return;
    }

    this.props.onSubmit({body: body, media: this.state.media});
    this.setState({body: '', media: []});
    if (this.fileInput) this.fileInput.value = '';
  }

  render () {
    return (
      <div className="card my-4">
          <h5 className="card-header">Оставить комментарий:</h5>
          <div className="card-body">
            <form onSubmit={this.handleSubmit}>
              <div className="form-group">
                <textarea 
                  className="form-control" 
                  rows="3" 
                  name="body" 
                  value={this.state.body} 
                  onChange={this.handleBodyChange}></textarea>
              </div>
              <div className="form-group">
                <label htmlFor="comment-media">Фото, видео или аудио</label>
                <input id="comment-media" ref={(input) => { this.fileInput = input; }} type="file" multiple accept="image/*,video/*,audio/*" onChange={this.handleMediaChange} className="form-control-file" />
                <small className="form-text text-muted">До 10 файлов. Изображения до 15 МБ, аудио до 100 МБ, видео до 250 МБ.</small>
              </div>
              <input type="hidden" value={this.props.csrf_token} />
              <button type="submit" className="btn btn-primary">Отправить</button>
            </form>
          </div>
        </div>
    );
  }
}

export default CommentForm
