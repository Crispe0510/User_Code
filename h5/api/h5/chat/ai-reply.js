const DEEPSEEK_API_URL = 'https://api.deepseek.com/chat/completions'
const DEEPSEEK_MODEL = 'deepseek-chat'

function parseBody(body) {
  if (!body) return {}
  if (typeof body === 'string') {
    try {
      return JSON.parse(body)
    } catch {
      return {}
    }
  }
  return body
}

function json(res, status, payload) {
  res.status(status).json(payload)
}

function buildPrompt(topicTitle) {
  const title = topicTitle || 'this family conversation topic'
  return [
    'You are Bridge AI, a warm and empathetic family conversation facilitator.',
    'Help family members across generations have meaningful, comfortable conversations.',
    `Current topic: "${title}".`,
    'Respond in the same language as the user interface or conversation context.',
    'Keep the response concise, warm, and practical: 2-3 sentences maximum.',
    'Ask one gentle follow-up question or offer one conversation angle.',
  ].join('\n')
}

export default async function handler(req, res) {
  if (req.method !== 'POST') {
    return json(res, 405, { code: 405, msg: 'Method not allowed', data: null })
  }

  const apiKey = process.env.DEEPSEEK_API_KEY
  if (!apiKey) {
    return json(res, 500, {
      code: 500,
      msg: 'Missing DEEPSEEK_API_KEY environment variable',
      data: null,
    })
  }

  const body = parseBody(req.body)
  const topicTitle = body.topicTitle || ''

  try {
    const aiRes = await fetch(DEEPSEEK_API_URL, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${apiKey}`,
      },
      body: JSON.stringify({
        model: DEEPSEEK_MODEL,
        stream: false,
        max_tokens: 500,
        messages: [
          { role: 'system', content: buildPrompt(topicTitle) },
          {
            role: 'user',
            content: 'Please suggest a helpful next message for this conversation.',
          },
        ],
      }),
    })

    if (!aiRes.ok) {
      const detail = await aiRes.text()
      return json(res, 502, {
        code: 502,
        msg: `AI service unavailable: ${detail || aiRes.statusText}`,
        data: null,
      })
    }

    const result = await aiRes.json()
    const content = result?.choices?.[0]?.message?.content?.trim()
    if (!content) {
      return json(res, 502, {
        code: 502,
        msg: 'AI service returned an empty response',
        data: null,
      })
    }

    return json(res, 200, {
      code: 200,
      msg: 'success',
      data: {
        id: `ai-${Date.now()}`,
        senderType: 'ai',
        senderName: 'AI',
        memberId: null,
        content,
        createdAt: new Date().toISOString(),
      },
    })
  } catch (error) {
    return json(res, 502, {
      code: 502,
      msg: `AI service unavailable: ${error.message}`,
      data: null,
    })
  }
}
