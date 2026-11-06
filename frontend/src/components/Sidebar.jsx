export default function Sidebar({
  activePage,
  onNavigate,
  user,
  currentDivision,
  onToggleDivision,
  onOpenAuthModal,
  onLogout
}) {
  const isOwnerDivision = currentDivision === 'owner'

  const ownerMenuItems = [
    ['Dashboard', '▦'],
    ['Voyages', '◌'],
    ['Inventory', '▤'],
    ['Audits', '✓'],
    ['Verify report', '⌘'],
    ['Live Tracking', '🚢'],
  ]

  const userMenuItems = [
    ['Live Tracking', '🚢'],
    ['Inventory', '▤'],
    ['Verify report', '⌘'],
    ['Dashboard', '▦'],
  ]

  const items = isOwnerDivision ? ownerMenuItems : userMenuItems

  // Generate 2 initials from user full name
  const initials = user?.fullName
    ? user.fullName.split(' ').map(n => n[0]).join('').slice(0, 2).toUpperCase()
    : (user?.username ? user.username.slice(0, 2).toUpperCase() : 'CV')

  return (
    <aside className="sidebar">
      {/* Brand logo */}
      <div className="brand" onClick={() => onNavigate('Dashboard')} style={{ cursor: 'pointer' }}>
        <span className="brand-mark">◈</span>
        <span>Cloud<span>Voyage</span></span>
      </div>

      {/* Division Switcher Capsule */}
      <div className="division-switcher-box">
        <span className="division-switch-title">PORTAL DIVISION</span>
        <button
          type="button"
          className={`division-toggle-btn ${isOwnerDivision ? 'owner-active' : 'user-active'}`}
          onClick={onToggleDivision}
          title="Click to toggle between Owner and Customer portals"
        >
          {isOwnerDivision ? (
            <><span>🏢</span> <strong>Owner Division</strong> <small>⇄</small></>
          ) : (
            <><span>👤</span> <strong>User Division</strong> <small>⇄</small></>
          )}
        </button>
      </div>

      <p className="workspace-label">
        {isOwnerDivision ? 'LOGISTICS OPERATIONS' : 'CUSTOMER CONSIGNMENT'}
      </p>

      {/* Navigation menu */}
      <nav>
        {items.map(([label, icon]) => (
          <button
            key={label}
            className={`nav-item ${activePage === label ? 'active' : ''}`}
            onClick={() => onNavigate(label)}
          >
            <span className="nav-icon">{icon}</span>
            <span className="nav-text">{label}</span>
          </button>
        ))}
      </nav>

      {/* Sidebar bottom with User Profile or Login button */}
      <div className="sidebar-bottom">
        {user ? (
          <div className="profile-logged-in">
            <div className="profile">
              <div className="avatar">{initials}</div>
              <div className="profile-text">
                <strong>{user.fullName || user.username}</strong>
                <small className="user-role-badge">{user.role || 'Member'}</small>
              </div>
            </div>
            <button
              type="button"
              className="btn-logout"
              onClick={onLogout}
              title="Sign Out"
            >
              Sign out ⎋
            </button>
          </div>
        ) : (
          <button
            type="button"
            className="btn-sidebar-signin"
            onClick={onOpenAuthModal}
          >
            <span>🔐</span> Sign In / Sign Up
          </button>
        )}
      </div>
    </aside>
  )
}
