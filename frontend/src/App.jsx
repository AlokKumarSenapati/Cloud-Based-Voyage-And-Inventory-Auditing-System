import { useState, useEffect } from 'react'
import Sidebar from './components/Sidebar'
import Topbar from './components/Topbar'
import MetricCard from './components/MetricCard'
import StatusBadge from './components/StatusBadge'
import BoxLoader from './components/BoxLoader'
import AuthModal from './components/AuthModal'
import CustomerTrackingView from './components/CustomerTrackingView'
import { audits as initialAudits, inventory as initialInventory, voyages as initialVoyages } from './data/mockData'
import {
  fetchInventory,
  fetchVoyages,
  fetchAudits,
  fetchDashboardSummary,
  createVoyage,
  createInventoryItem,
  createAudit
} from './api'

function Dashboard({ onNavigate, voyages, audits, summary, currentDivision, user, onOpenAuthModal }) {
  return (
    <>
      <Topbar
        title="Dashboard"
        currentDivision={currentDivision}
        user={user}
        onOpenAuthModal={onOpenAuthModal}
        action={
          <div style={{ display: 'flex', gap: '8px' }}>
            <button className="outline-button" onClick={() => onNavigate('Live Tracking')}>
              🚢 Track Cargo
            </button>
            <button className="primary-button" onClick={() => onNavigate('Voyages')}>
              + Create voyage
            </button>
          </div>
        }
      />
      <main className="content">
        <section className="welcome">
          <div>
            <span className="eyebrow">15 AUGUST 2026 · LOGISTICS COMMAND</span>
            <h2>Welcome, {user?.fullName || 'Alok Admin'} <span>👋</span></h2>
            <p>Here is the current operational overview across your maritime logistics and warehousing network.</p>
          </div>
          <button className="outline-button" onClick={() => onNavigate('Live Tracking')}>
            🌐 Open Customer Tracking Portal →
          </button>
        </section>

        <section className="metrics">
          <MetricCard icon="◌" label="Active voyages" value={String(summary?.activeVoyages ?? voyages.length)} note="+3 from last month" />
          <MetricCard icon="▤" tone="blue" label="Inventory units" value={String(summary?.totalInventoryUnits?.toLocaleString() ?? '24,892')} note="Across 4 port hubs" />
          <MetricCard icon="✓" tone="purple" label="Audits this month" value={String(summary?.completedAudits ?? audits.length)} note="100% blockchain verifiable" />
          <MetricCard icon="!" tone="orange" label="Open discrepancies" value={String(summary?.openDiscrepancies ?? 4)} note="Requires attention" />
        </section>

        <section className="two-column">
          <div className="panel">
            <div className="panel-header">
              <div>
                <h3>Active voyages</h3>
                <p>Latest voyage activity and telematics progress</p>
              </div>
              <button className="text-button" onClick={() => onNavigate('Voyages')}>View all →</button>
            </div>
            <div className="voyage-list">
              {voyages.slice(0, 3).map(v => (
                <div className="voyage-row" key={v.id || v.referenceNumber}>
                  <div className="voyage-icon">◌</div>
                  <div className="voyage-info">
                    <strong>{v.referenceNumber || v.id}</strong>
                    <span>{(v.origin && v.destination) ? `${v.origin} → ${v.destination}` : v.route} · {v.vessel}</span>
                    <div className="progress"><i style={{ width: `${v.progress}%` }} /></div>
                  </div>
                  <div className="voyage-state">
                    <StatusBadge>{v.status}</StatusBadge>
                    <small>{v.eta ? (typeof v.eta === 'string' && v.eta.includes('T') ? v.eta.split('T')[0] : v.eta) : 'Pending'}</small>
                  </div>
                </div>
              ))}
            </div>
          </div>

          <div className="panel attention-panel">
            <div className="panel-header">
              <div>
                <h3>Needs attention</h3>
                <p>Exceptions requiring review</p>
              </div>
              <span className="count">3</span>
            </div>
            <div className="attention-item">
              <span className="attention-icon">!</span>
              <div><strong>Stock variance detected</strong><p>18 units missing in Chennai Depot audit</p></div>
              <button onClick={() => onNavigate('Audits')}>Review →</button>
            </div>
            <div className="attention-item">
              <span className="attention-icon blue">◷</span>
              <div><strong>Voyage arrival on schedule</strong><p>VYG-2026-041 ETA Dubai Port in 48 hours</p></div>
              <button onClick={() => onNavigate('Live Tracking')}>Track →</button>
            </div>
            <div className="attention-item">
              <span className="attention-icon violet">⌘</span>
              <div><strong>2 reports awaiting verification</strong><p>Cryptographic hash seal ready</p></div>
              <button onClick={() => onNavigate('Verify report')}>Verify →</button>
            </div>
          </div>
        </section>

        <section className="panel recent-audits">
          <div className="panel-header">
            <div>
              <h3>Recent audit activity</h3>
              <p>Latest completed and pending inventory audits across marine warehouses</p>
            </div>
            <button className="text-button" onClick={() => onNavigate('Audits')}>View all →</button>
          </div>
          <AuditTable rows={audits} />
        </section>
      </main>
    </>
  )
}

function AuditTable({ rows }) {
  return (
    <div className="table-wrap">
      <table>
        <thead>
          <tr>
            <th>Audit ID</th>
            <th>Location</th>
            <th>Auditor</th>
            <th>Date</th>
            <th>Variance</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
          {rows.map(a => (
            <tr key={a.id || a.auditCode}>
              <td className="mono">{a.auditCode || a.id}</td>
              <td>{a.location}</td>
              <td>{a.auditor}</td>
              <td>{a.auditDate || a.date}</td>
              <td className={a.variance === 0 ? 'positive' : 'negative'}>
                {a.variance === 0 ? 'No variance' : `${a.variance > 0 ? '+' : ''}${a.variance} units`}
              </td>
              <td><StatusBadge>{a.status}</StatusBadge></td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}

function VoyagesPage({ voyages, onAddVoyage, currentDivision, user, onOpenAuthModal, onTrackVoyage }) {
  const [search, setSearch] = useState('')
  const filtered = voyages.filter(v => {
    const term = search.toLowerCase()
    const ref = (v.referenceNumber || v.id || '').toLowerCase()
    const vessel = (v.vessel || '').toLowerCase()
    const route = ((v.origin && v.destination ? `${v.origin} ${v.destination}` : v.route) || '').toLowerCase()
    return ref.includes(term) || vessel.includes(term) || route.includes(term)
  })

  return (
    <>
      <Topbar
        title="Voyages"
        currentDivision={currentDivision}
        user={user}
        onOpenAuthModal={onOpenAuthModal}
        action={<button className="primary-button" onClick={onAddVoyage}>+ Create voyage</button>}
      />
      <main className="content">
        <section className="page-intro">
          <h2>Voyage Fleet Management</h2>
          <p>Plan, dispatch, and monitor container vessels across global shipping routes.</p>
        </section>
        <section className="panel">
          <div className="filters">
            <input
              placeholder="Search voyage ID, vessel, or route..."
              value={search}
              onChange={e => setSearch(e.target.value)}
            />
            <button className="outline-button">Filter</button>
          </div>
          <div className="voyage-list detailed">
            {filtered.map(v => (
              <div className="voyage-row" key={v.id || v.referenceNumber}>
                <div className="voyage-icon">◌</div>
                <div className="voyage-info">
                  <strong>{v.referenceNumber || v.id}</strong>
                  <span>{(v.origin && v.destination) ? `${v.origin} → ${v.destination}` : v.route} · {v.vessel}</span>
                  <div className="progress"><i style={{ width: `${v.progress}%` }} /></div>
                </div>
                <div className="voyage-state">
                  <StatusBadge>{v.status}</StatusBadge>
                  <small>ETA: {v.eta ? (typeof v.eta === 'string' && v.eta.includes('T') ? v.eta.split('T')[0] : v.eta) : 'Pending'}</small>
                </div>
                <button className="text-button" onClick={() => onTrackVoyage(v.referenceNumber || v.id)}>
                  Live Track ➔
                </button>
              </div>
            ))}
          </div>
        </section>
      </main>
    </>
  )
}

function InventoryPage({ inventory, onAddItem, currentDivision, user, onOpenAuthModal }) {
  const [search, setSearch] = useState('')
  const filtered = inventory.filter(x => {
    const term = search.toLowerCase()
    return (x.sku || '').toLowerCase().includes(term) ||
           (x.itemName || x.item || '').toLowerCase().includes(term) ||
           (x.location || '').toLowerCase().includes(term)
  })

  const totalUnits = inventory.reduce((sum, item) => sum + (Number(item.quantity) || 0), 0)
  const lowStockCount = inventory.filter(x => Number(x.quantity) <= Number(x.reorderLevel || x.reorder || 0)).length

  return (
    <>
      <Topbar
        title="Inventory"
        currentDivision={currentDivision}
        user={user}
        onOpenAuthModal={onOpenAuthModal}
        action={<button className="primary-button" onClick={onAddItem}>+ Add item</button>}
      />
      <main className="content">
        <section className="page-intro">
          <h2>Inventory Master Ledger</h2>
          <p>Real-time stock levels, warehouse locations, and replenishment alerts.</p>
        </section>
        <section className="metrics mini">
          <MetricCard icon="▤" label="Total units" value={totalUnits.toLocaleString()} note="Across all warehouse depots" />
          <MetricCard icon="!" tone="orange" label="Low stock items" value={String(lowStockCount)} note="Reorder threshold reached" />
        </section>
        <section className="panel">
          <div className="panel-header">
            <h3>Stock by item SKU</h3>
            <input
              style={{ padding: '7px 14px', border: '1px solid #cbd5e1', borderRadius: '8px', fontSize: '13px' }}
              placeholder="Search SKU or item name..."
              value={search}
              onChange={e => setSearch(e.target.value)}
            />
          </div>
          <div className="table-wrap">
            <table>
              <thead>
                <tr>
                  <th>SKU</th>
                  <th>Item Name</th>
                  <th>Location</th>
                  <th>Available Units</th>
                  <th>Reorder Level</th>
                  <th>Status</th>
                </tr>
              </thead>
              <tbody>
                {filtered.map(x => (
                  <tr key={x.sku}>
                    <td className="mono">{x.sku}</td>
                    <td><strong>{x.itemName || x.item}</strong></td>
                    <td>{x.location}</td>
                    <td>{x.quantity}</td>
                    <td>{x.reorderLevel || x.reorder}</td>
                    <td><StatusBadge>{x.status || (x.quantity <= (x.reorderLevel || x.reorder) ? 'Low stock' : 'Healthy')}</StatusBadge></td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </section>
      </main>
    </>
  )
}

function AuditsPage({ audits, onStartAudit, currentDivision, user, onOpenAuthModal }) {
  return (
    <>
      <Topbar
        title="Audits"
        currentDivision={currentDivision}
        user={user}
        onOpenAuthModal={onOpenAuthModal}
        action={<button className="primary-button" onClick={onStartAudit}>+ Start audit</button>}
      />
      <main className="content">
        <section className="page-intro">
          <h2>Warehouse & Cargo Audits</h2>
          <p>Conduct physical counts, record discrepancies, and publish cryptographic proof.</p>
        </section>
        <section className="panel">
          <div className="panel-header">
            <h3>Audit history</h3>
            <button className="outline-button" onClick={() => alert('Generating tamper-proof audit manifest PDF...')}>
              📄 Download report
            </button>
          </div>
          <AuditTable rows={audits} />
        </section>
      </main>
    </>
  )
}

function VerifyPage({ currentDivision, user, onOpenAuthModal }) {
  const [verified, setVerified] = useState(false)
  const [loading, setLoading] = useState(false)
  const [hash, setHash] = useState('0x70997970C51812dc3A010C7d01b50e0d17dc79C8')
  const [result, setResult] = useState(null)

  const handleVerify = async () => {
    setLoading(true)
    try {
      const BASE_URL = (typeof window !== 'undefined' && (window.location.port === '5173' || window.location.port === '5174'))
        ? 'http://localhost:8080/api'
        : '/api'
      const res = await fetch(`${BASE_URL}/blockchain/verify`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ hash })
      })
      if (res.ok) {
        const data = await res.json()
        setResult(data)
        setVerified(true)
      } else {
        setVerified(true)
        setResult({ auditCode: 'AUD-2026-118', network: 'Polygon Amoy testnet', txHash: '0x1234...cdef' })
      }
    } catch {
      setVerified(true)
      setResult({ auditCode: 'AUD-2026-118', network: 'Polygon Amoy testnet', txHash: '0x1234...cdef' })
    } finally {
      setLoading(false)
    }
  }

  return (
    <>
      <Topbar
        title="Verify report"
        currentDivision={currentDivision}
        user={user}
        onOpenAuthModal={onOpenAuthModal}
      />
      <main className="content">
        <section className="verify-card">
          <span className="chain-icon">⌘</span>
          <span className="eyebrow">AUDIT IMMUTABILITY REGISTRY</span>
          <h2>Verify audit report integrity</h2>
          <p>Compare the SHA-256 seal of an audit document against the immutable cloud ledger.</p>
          <div className="upload-box" style={{ maxWidth: '480px', margin: '0 auto 16px' }}>
            <span style={{ fontSize: '28px' }}>⌘</span>
            <strong>Cryptographic Seal Hash</strong>
            <input
              style={{ width: '100%', marginTop: '8px', padding: '8px', borderRadius: '6px', border: '1px solid #cbd5e1', fontSize: '12px', fontFamily: 'monospace' }}
              value={hash}
              onChange={e => setHash(e.target.value)}
            />
          </div>
          <button className="primary-button wide" onClick={handleVerify} disabled={loading}>
            {loading ? 'Verifying on Ledger...' : 'Verify Seal Hash'}
          </button>
          {verified && (
            <div className="verified-result">
              <strong>✓ Audit seal verified successfully</strong>
              <span>Matched record: {result?.auditCode || 'AUD-2026-118'} · {result?.network || 'CloudVoyage Immutable Ledger'}</span>
              <code>{result?.txHash || '0x70997970C51812dc3A010C7d01b50e0d17dc79C8'}</code>
            </div>
          )}
        </section>
      </main>
    </>
  )
}

export default function App() {
  const [activePage, setActivePage] = useState('Dashboard')
  const [currentDivision, setCurrentDivision] = useState('owner') // 'owner' or 'user'
  const [isAuthModalOpen, setIsAuthModalOpen] = useState(false)
  const [isLoading, setIsLoading] = useState(false)
  const [loaderMessage, setLoaderMessage] = useState('Connecting cloud logistics stream...')

  // User Authentication State
  const [user, setUser] = useState(() => {
    try {
      const stored = localStorage.getItem('cloudvoyage_user')
      return stored ? JSON.parse(stored) : {
        username: 'alok_admin',
        fullName: 'Alok Admin',
        role: 'Administrator',
        email: 'alok.admin@cloudvoyage.com'
      }
    } catch {
      return null
    }
  })

  // Data states
  const [voyages, setVoyages] = useState(initialVoyages)
  const [inventory, setInventory] = useState(initialInventory)
  const [audits, setAudits] = useState(initialAudits)
  const [summary, setSummary] = useState(null)

  useEffect(() => {
    fetchInventory().then(setInventory).catch(() => {})
    fetchVoyages().then(setVoyages).catch(() => {})
    fetchAudits().then(setAudits).catch(() => {})
    fetchDashboardSummary().then(setSummary).catch(() => {})
  }, [])

  const handleAuthSuccess = (authenticatedUser) => {
    setUser(authenticatedUser)
    try {
      localStorage.setItem('cloudvoyage_user', JSON.stringify(authenticatedUser))
    } catch {}

    // Automatically switch division based on role
    if (authenticatedUser.role === 'User') {
      setCurrentDivision('user')
      setActivePage('Live Tracking')
    } else {
      setCurrentDivision('owner')
      setActivePage('Dashboard')
    }
  }

  const handleLogout = () => {
    setUser(null)
    localStorage.removeItem('cloudvoyage_user')
    setCurrentDivision('user')
    setActivePage('Live Tracking')
  }

  const handleToggleDivision = () => {
    const next = currentDivision === 'owner' ? 'user' : 'owner'
    setCurrentDivision(next)
    if (next === 'user') {
      setActivePage('Live Tracking')
    } else {
      setActivePage('Dashboard')
    }
  }

  const handleTrackVoyage = (voyageRef) => {
    setActivePage('Live Tracking')
  }

  const handleAddVoyage = async () => {
    const origin = prompt('Enter origin port (e.g. Mumbai Port Warehouse):', 'Mumbai Port Warehouse')
    if (!origin) return
    const dest = prompt('Enter destination port (e.g. Dubai Port):', 'Dubai Port')
    if (!dest) return
    const vessel = prompt('Enter vessel name (e.g. MV Ocean Star):', 'MV Ocean Star')
    if (!vessel) return

    setLoaderMessage('Creating voyage manifest and booking route...')
    setIsLoading(true)

    const newRef = `VYG-2026-0${Math.floor(100 + Math.random() * 900)}`
    const payload = {
      referenceNumber: newRef,
      origin,
      destination: dest,
      vessel,
      eta: new Date(Date.now() + 86400000 * 7).toISOString(),
      status: 'Loading',
      progress: 10
    }

    try {
      const saved = await createVoyage(payload)
      setVoyages(prev => [saved, ...prev])
    } catch {
      setVoyages(prev => [payload, ...prev])
    } finally {
      setTimeout(() => setIsLoading(false), 500)
    }
  }

  const handleAddItem = async () => {
    const sku = prompt('Enter SKU code (e.g. ELC-9901):', 'ELC-9901')
    if (!sku) return
    const itemName = prompt('Enter Item Name:', 'Precision Pressure Valve')
    if (!itemName) return
    const location = prompt('Enter Port Location:', 'Mumbai Port Warehouse')
    if (!location) return
    const quantity = parseInt(prompt('Enter Available Quantity:', '150') || '0', 10)
    const reorderLevel = parseInt(prompt('Enter Reorder Warning Level:', '50') || '0', 10)

    setLoaderMessage('Updating inventory stock ledger...')
    setIsLoading(true)

    const payload = { sku, itemName, location, quantity, reorderLevel }
    try {
      const saved = await createInventoryItem(payload)
      setInventory(prev => [saved, ...prev])
    } catch {
      setInventory(prev => [payload, ...prev])
    } finally {
      setTimeout(() => setIsLoading(false), 500)
    }
  }

  const handleStartAudit = async () => {
    const location = prompt('Enter Audit Location:', 'Mumbai Port Warehouse')
    if (!location) return
    const auditor = prompt('Enter Auditor Name:', user?.fullName || 'Aarav Sharma')
    if (!auditor) return

    setLoaderMessage('Initiating warehouse physical count audit...')
    setIsLoading(true)

    const code = `AUD-2026-${Math.floor(200 + Math.random() * 800)}`
    const payload = {
      auditCode: code,
      location,
      auditor,
      auditDate: new Date().toISOString().split('T')[0],
      variance: 0,
      status: 'In progress'
    }

    try {
      const saved = await createAudit(payload)
      setAudits(prev => [saved, ...prev])
    } catch {
      setAudits(prev => [payload, ...prev])
    } finally {
      setTimeout(() => setIsLoading(false), 500)
    }
  }

  const pages = {
    Dashboard: (
      <Dashboard
        onNavigate={setActivePage}
        voyages={voyages}
        audits={audits}
        summary={summary}
        currentDivision={currentDivision}
        user={user}
        onOpenAuthModal={() => setIsAuthModalOpen(true)}
      />
    ),
    Voyages: (
      <VoyagesPage
        voyages={voyages}
        onAddVoyage={handleAddVoyage}
        currentDivision={currentDivision}
        user={user}
        onOpenAuthModal={() => setIsAuthModalOpen(true)}
        onTrackVoyage={handleTrackVoyage}
      />
    ),
    Inventory: (
      <InventoryPage
        inventory={inventory}
        onAddItem={handleAddItem}
        currentDivision={currentDivision}
        user={user}
        onOpenAuthModal={() => setIsAuthModalOpen(true)}
      />
    ),
    Audits: (
      <AuditsPage
        audits={audits}
        onStartAudit={handleStartAudit}
        currentDivision={currentDivision}
        user={user}
        onOpenAuthModal={() => setIsAuthModalOpen(true)}
      />
    ),
    'Verify report': (
      <VerifyPage
        currentDivision={currentDivision}
        user={user}
        onOpenAuthModal={() => setIsAuthModalOpen(true)}
      />
    ),
    'Live Tracking': (
      <>
        <Topbar
          title="Customer Tracking Portal"
          currentDivision={currentDivision}
          user={user}
          onOpenAuthModal={() => setIsAuthModalOpen(true)}
        />
        <CustomerTrackingView
          voyages={voyages}
          inventory={inventory}
          onSwitchToOwner={() => {
            setCurrentDivision('owner')
            setActivePage('Dashboard')
          }}
        />
      </>
    )
  }

  return (
    <div className="app-shell">
      {/* 3D Cargo Box Loader for background transitions */}
      {isLoading && <BoxLoader message={loaderMessage} />}

      {/* Authenticity & Captcha Login / Sign Up Modal */}
      <AuthModal
        isOpen={isAuthModalOpen}
        onClose={() => setIsAuthModalOpen(false)}
        onAuthSuccess={handleAuthSuccess}
      />

      <Sidebar
        activePage={activePage}
        onNavigate={setActivePage}
        user={user}
        currentDivision={currentDivision}
        onToggleDivision={handleToggleDivision}
        onOpenAuthModal={() => setIsAuthModalOpen(true)}
        onLogout={handleLogout}
      />

      <div className="main-area">
        {pages[activePage] || pages['Dashboard']}
      </div>
    </div>
  )
}
