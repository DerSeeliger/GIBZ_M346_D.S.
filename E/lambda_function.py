import json

def lambda_handler(event, context):
    html = """<!DOCTYPE html>
<html>
<head><title>M346 Serverless Function</title>
<style>
  body{font-family:sans-serif;max-width:600px;margin:50px auto;padding:20px;background:#f5f5f5}
  h1{color:#232f3e}
  .info{background:white;padding:20px;border-radius:8px;border-left:4px solid #ff9900}
  .tag{display:inline-block;background:#ff9900;color:white;padding:2px 8px;border-radius:4px;font-size:0.8em}
</style>
</head>
<body>
<h1>M346 Cloud Project <span class="tag">Serverless</span></h1>
<div class="info">
  <p><strong>Student:</strong> david-seeliger</p>
  <p><strong>Service:</strong> AWS Lambda</p>
  <p><strong>Runtime:</strong> Python 3.12</p>
  <p><strong>Compute type:</strong> Serverless &mdash; no servers to manage, scales to zero</p>
  <p><strong>Trigger:</strong> API Gateway HTTP API</p>
  <p><strong>Invocation:</strong> Event-driven (HTTP GET request)</p>
</div>
</body>
</html>"""

    return {
        'statusCode': 200,
        'headers': {'Content-Type': 'text/html'},
        'body': html
    }
