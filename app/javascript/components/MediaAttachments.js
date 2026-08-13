import React from "react";

class MediaAttachments extends React.Component {
  renderAttachment(attachment) {
    if (!attachment || !attachment.url) return null;

    if ((attachment.content_type || '').startsWith('image/')) {
      return <img className="img-fluid rounded mb-2" src={attachment.url} alt={attachment.filename} />;
    }

    if ((attachment.content_type || '').startsWith('video/')) {
      return <video className="w-100 rounded mb-2" controls preload="metadata"><source src={attachment.url} type={attachment.content_type} /></video>;
    }

    return (
      <div className="border rounded p-2 mb-2">
        <div className="small text-muted">{attachment.filename}</div>
        <audio className="w-100 mt-2" controls preload="metadata"><source src={attachment.url} type={attachment.content_type} /></audio>
      </div>
    );
  }

  render() {
    const media = this.props.media || [];
    if (!media.length) return null;

    return <div className="media-attachments mt-2">{media.map((attachment) => <div key={attachment.id || attachment.url}>{this.renderAttachment(attachment)}</div>)}</div>;
  }
}

export default MediaAttachments;
