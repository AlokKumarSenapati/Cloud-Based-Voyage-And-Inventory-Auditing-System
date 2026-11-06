import { useRef, useEffect } from 'react'

export default function CaptchaCanvas({ visualCode, width = 160, height = 48 }) {
  const canvasRef = useRef(null)

  useEffect(() => {
    const canvas = canvasRef.current
    if (!canvas || !visualCode) return
    const ctx = canvas.getContext('2d')

    // Background gradient
    const gradient = ctx.createLinearGradient(0, 0, width, height)
    gradient.addColorStop(0, '#f1f5f9')
    gradient.addColorStop(1, '#e2e8f0')
    ctx.fillStyle = gradient
    ctx.fillRect(0, 0, width, height)

    // Background noise dots
    for (let i = 0; i < 40; i++) {
      ctx.fillStyle = `rgba(${Math.floor(Math.random() * 150)}, ${Math.floor(Math.random() * 150)}, ${Math.floor(Math.random() * 150)}, 0.4)`
      ctx.beginPath()
      ctx.arc(Math.random() * width, Math.random() * height, Math.random() * 2, 0, Math.PI * 2)
      ctx.fill()
    }

    // Noise curved lines
    for (let i = 0; i < 4; i++) {
      ctx.strokeStyle = `rgba(${Math.floor(Math.random() * 120)}, ${Math.floor(Math.random() * 120)}, ${Math.floor(Math.random() * 200)}, 0.6)`
      ctx.lineWidth = 1.5
      ctx.beginPath()
      ctx.moveTo(Math.random() * width, Math.random() * height)
      ctx.bezierCurveTo(
        Math.random() * width, Math.random() * height,
        Math.random() * width, Math.random() * height,
        Math.random() * width, Math.random() * height
      )
      ctx.stroke()
    }

    // Render each character with random rotation, color, and vertical offset
    const chars = visualCode.split('')
    const charSpacing = width / (chars.length + 1)

    chars.forEach((char, idx) => {
      ctx.save()
      const x = (idx + 0.8) * charSpacing
      const y = height / 2 + (Math.random() * 8 - 4)
      const angle = (Math.random() * 30 - 15) * (Math.PI / 180)

      ctx.translate(x, y)
      ctx.rotate(angle)

      const colors = ['#0f172a', '#1e3a8a', '#0369a1', '#0f766e', '#15803d', '#7e22ce']
      ctx.fillStyle = colors[Math.floor(Math.random() * colors.length)]
      ctx.font = 'bold 22px "Courier New", monospace'
      ctx.textAlign = 'center'
      ctx.textBaseline = 'middle'
      ctx.fillText(char, 0, 0)

      ctx.restore()
    })
  }, [visualCode, width, height])

  return (
    <canvas
      ref={canvasRef}
      width={width}
      height={height}
      className="captcha-canvas"
      title="Security Captcha Image"
    />
  )
}

