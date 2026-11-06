export default function MetricCard({ label, value, note, icon, tone = 'teal' }) {
  return <article className="metric-card"><div className={`metric-icon ${tone}`}>{icon}</div><div><p>{label}</p><strong>{value}</strong><small className={note.startsWith('+') ? 'positive' : ''}>{note}</small></div></article>
}
