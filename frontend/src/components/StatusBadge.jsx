export default function StatusBadge({ children }) {
  const kind = children === 'Completed' || children === 'Blockchain verified' || children === 'Healthy' ? 'good' : children === 'Action required' || children === 'Low stock' ? 'warning' : 'info'
  return <span className={`status ${kind}`}>{children}</span>
}
