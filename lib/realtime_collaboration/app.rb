# frozen_string_literal: true

module RealtimeCollaboration
  class App
    HTML = <<~HTML
      <!doctype html>
      <html lang="en">
        <head>
          <meta charset="utf-8">
          <meta name="viewport" content="width=device-width, initial-scale=1">
          <title>Realtime Collaboration</title>
          <style>
            body { margin: 0; font-family: Arial, sans-serif; background: #f7f8fa; color: #171717; }
            main { max-width: 760px; margin: 0 auto; padding: 32px 16px; }
            textarea { box-sizing: border-box; width: 100%; min-height: 280px; padding: 16px; border: 1px solid #b8c0cc; border-radius: 8px; font: inherit; resize: vertical; }
            p { min-height: 24px; }
            button { border: 0; border-radius: 8px; padding: 10px 14px; background: #176b87; color: white; font: inherit; }
          </style>
        </head>
        <body>
          <main>
            <h1>Shared workspace</h1>
            <textarea id="content" aria-label="Shared content"></textarea>
            <p id="notice"></p>
            <button id="send" type="button">Share update</button>
          </main>
          <script>
            const socket = new WebSocket(`${location.protocol === 'https:' ? 'wss' : 'ws'}://${location.host}/cable`);
            const identifier = JSON.stringify({ channel: 'RealtimeCollaboration::CollaborationChannel' });
            const content = document.getElementById('content');
            const notice = document.getElementById('notice');

            socket.addEventListener('open', () => {
              socket.send(JSON.stringify({ command: 'subscribe', identifier }));
            });

            socket.addEventListener('message', (event) => {
              const frame = JSON.parse(event.data);
              if (!frame.message) return;
              if (frame.message.type === 'state') content.value = frame.message.state.content;
              if (frame.message.type === 'notification') notice.textContent = frame.message.message;
            });

            document.getElementById('send').addEventListener('click', () => {
              socket.send(JSON.stringify({
                command: 'message',
                identifier,
                data: JSON.stringify({ action: 'update', content: content.value })
              }));
            });
          </script>
        </body>
      </html>
    HTML

    def call(env)
      return [200, { 'Content-Type' => 'text/html' }, [HTML]] if env.fetch('PATH_INFO') == '/'

      [404, { 'Content-Type' => 'text/plain' }, ['Not Found']]
    end
  end
end
