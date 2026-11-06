export default function Topbar({
  title,
  action,
  currentDivision,
  user,
  onOpenAuthModal
}) {
  const isOwner = currentDivision === 'owner'

  return (
    <header className="topbar">
      <div>
        <div className="crumb-row">
          <span className="crumb">Workspace</span>
          <span className="crumb-sep">/</span>
          <span className={`crumb-division-pill ${isOwner ? 'owner' : 'user'}`}>
            {isOwner ? '🏢 Owner Division' : '👤 Customer Division'}
          </span>
          <span className="crumb-sep">/</span>
          <span className="crumb-page">{title}</span>
        </div>
        <h1>{title}</h1>
      </div>

      <div className="top-actions">
        {user ? (
          <div className="topbar-user-badge">
            <span className="user-indicator-dot online"></span>
            <span className="user-greeting">Signed in as <strong>{user.fullName || user.username}</strong></span>
          </div>
        ) : (
          <button
            type="button"
            className="topbar-auth-btn"
            onClick={onOpenAuthModal}
          >
            <span>🔐</span> Sign In
          </button>
        )}
        {action}
      </div>
    </header>
  )
}
