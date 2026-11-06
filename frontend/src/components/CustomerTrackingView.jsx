import { useState } from 'react'

export default function CustomerTrackingView({ voyages = [], inventory = [], onSwitchToOwner }) {
  const [trackingQuery, setTrackingQuery] = useState('VOY-2026-041')
  const [searchedRecord, setSearchedRecord] = useState(null)
  const [activeTab, setActiveTab] = useState('tracking') // 'tracking' or 'catalog'

  // Pre-selected default search
  const currentVoyage = voyages.find(v =>
    (v.referenceNumber && v.referenceNumber.toLowerCase() === trackingQuery.toLowerCase()) ||
    (v.id && String(v.id) === trackingQuery)
  ) || voyages[0] || {
    referenceNumber: 'VOY-2026-041',
    vessel: 'MV Ocean Star',
    origin: 'Mumbai Port Warehouse',
    destination: 'Dubai Port',
    progress: 68,
    status: 'In transit',
    eta: '2026-08-22'
  }

  const handleSearch = (e) => {
    e.preventDefault()
    const clean = trackingQuery.trim().toUpperCase()
    // Search in voyages
    const foundVoyage = voyages.find(v =>
      (v.referenceNumber && v.referenceNumber.toUpperCase().includes(clean)) ||
      (v.vessel && v.vessel.toUpperCase().includes(clean))
    )

    // Or search in inventory items
    const foundItem = inventory.find(i =>
      (i.sku && i.sku.toUpperCase().includes(clean)) ||
      (i.itemName && i.itemName.toUpperCase().includes(clean))
    )

    setSearchedRecord({ voyage: foundVoyage, item: foundItem, query: clean })
  }

  const displayVoyage = searchedRecord?.voyage || currentVoyage

  return (
    <div className="customer-tracking-portal">
      {/* Top Banner with Division Badge */}
      <div className="customer-hero">
        <div className="customer-hero-content">
          <div className="division-badge user-division-badge">
            <span className="dot pulse"></span> CUSTOMER & CONSIGNEE DIVISION
          </div>
          <h1>Live Cargo & Shipment Ocean Tracker</h1>
          <p>Real-time vessel telematics, container custody ledger, and tamper-proof verification.</p>

          {/* Search Box */}
          <form className="tracking-search-bar" onSubmit={handleSearch}>
            <span className="search-icon">🔍</span>
            <input
              type="text"
              placeholder="Enter Voyage No. (e.g. VOY-2026-041) or Item SKU (e.g. ELC-1204)..."
              value={trackingQuery}
              onChange={(e) => setTrackingQuery(e.target.value)}
            />
            <button type="submit" className="tracking-submit-btn">
              Track Cargo ➔
            </button>
          </form>

          {/* Quick Tracking Chips */}
          <div className="tracking-chips">
            <span className="chips-label">Quick samples:</span>
            {['VOY-2026-041', 'VOY-2026-042', 'ELC-1204', 'MEC-2351'].map(sample => (
              <button
                key={sample}
                type="button"
                className={`tracking-chip ${trackingQuery === sample ? 'active' : ''}`}
                onClick={() => { setTrackingQuery(sample); setSearchedRecord(null); }}
              >
                🏷️ {sample}
              </button>
            ))}
          </div>
        </div>

        {/* Decorative Floating Maritime Icons */}
        <div className="hero-decor">
          <div className="floating-ship-icon">🚢</div>
          <div className="floating-container-box">📦</div>
        </div>
      </div>

      {/* Main Content Area */}
      <div className="tracking-main-content">
        {/* Animated Ocean & Vessel Simulation Card */}
        <div className="tracking-card ocean-simulation-card">
          <div className="ocean-card-header">
            <div>
              <span className="eyebrow">OCEAN VOYAGE TELEMETRY</span>
              <h2>{displayVoyage.referenceNumber || 'VOY-2026-041'} · {displayVoyage.vessel}</h2>
              <p className="route-sub">
                ⚓ {displayVoyage.origin || 'Mumbai Port'} ➔ 🌊 Arabian Sea ➔ 🏁 {displayVoyage.destination || 'Dubai Port'}
              </p>
            </div>
            <div className="status-pill in-transit">
              <span className="dot pulse-blue"></span> {displayVoyage.status || 'In Transit'}
            </div>
          </div>

          {/* 3D Wave & Vessel Motion Visualizer */}
          <div className="animated-ocean-stage">
            <div className="sky-elements">
              <div className="cloud cloud-1">☁️</div>
              <div className="cloud cloud-2">☁️</div>
            </div>

            {/* Vessel sailing across with dynamic position */}
            <div
              className="sailing-vessel"
              style={{ left: `clamp(15%, ${displayVoyage.progress || 65}%, 85%)` }}
            >
              <div className="ship-body">
                <div className="ship-bridge"></div>
                <div className="ship-funnel">
                  <div className="smoke-particle"></div>
                </div>
                <div className="ship-containers">
                  <span className="c-box c-teal"></span>
                  <span className="c-box c-orange"></span>
                  <span className="c-box c-blue"></span>
                </div>
                <div className="ship-hull">🚢</div>
              </div>
              <div className="vessel-tag">
                <span>{displayVoyage.vessel}</span>
                <strong>{displayVoyage.progress || 68}% Completed</strong>
              </div>
            </div>

            {/* Layered Animated Waves */}
            <div className="ocean-waves">
              <div className="wave wave-back"></div>
              <div className="wave wave-mid"></div>
              <div className="wave wave-front"></div>
            </div>
          </div>

          {/* Progress Timeline */}
          <div className="shipment-timeline">
            <div className="timeline-node completed">
              <div className="node-icon">✓</div>
              <div className="node-info">
                <strong>Booking & Gate-In</strong>
                <small>{displayVoyage.origin || 'Origin Port'} · Complete</small>
              </div>
            </div>

            <div className="timeline-connector filled"></div>

            <div className="timeline-node completed">
              <div className="node-icon">✓</div>
              <div className="node-info">
                <strong>Gantry Loaded</strong>
                <small>Stowed on Manifest · Verified</small>
              </div>
            </div>

            <div className="timeline-connector filled"></div>

            <div className="timeline-node active">
              <div className="node-icon pulse">🚢</div>
              <div className="node-info">
                <strong>Ocean Transit</strong>
                <small>Speed: 18.4 knots · On Schedule</small>
              </div>
            </div>

            <div className="timeline-connector"></div>

            <div className="timeline-node pending">
              <div className="node-icon">🏁</div>
              <div className="node-info">
                <strong>Customs & Delivery</strong>
                <small>Est. {displayVoyage.eta ? String(displayVoyage.eta).split('T')[0] : '2026-08-22'}</small>
              </div>
            </div>
          </div>
        </div>

        {/* Two Column Details */}
        <div className="tracking-grid-details">
          {/* Manifest Specs */}
          <div className="tracking-card">
            <h3>📦 Cargo Manifest & Specs</h3>
            <div className="spec-table">
              <div className="spec-row">
                <span>Consignee Division</span>
                <strong>Commercial Freight / Client Verified</strong>
              </div>
              <div className="spec-row">
                <span>Origin Port Terminal</span>
                <strong>{displayVoyage.origin || 'Mumbai Port Warehouse'}</strong>
              </div>
              <div className="spec-row">
                <span>Destination Harbor</span>
                <strong>{displayVoyage.destination || 'Dubai Port Terminal'}</strong>
              </div>
              <div className="spec-row">
                <span>Gross Manifest Weight</span>
                <strong>14,250 kg (ISO Container)</strong>
              </div>
              <div className="spec-row">
                <span>Estimated Port Arrival</span>
                <strong>{displayVoyage.eta ? String(displayVoyage.eta).split('T')[0] : '2026-08-22'}</strong>
              </div>
            </div>
          </div>

          {/* Security & Authenticity Card */}
          <div className="tracking-card security-card">
            <div className="security-card-header">
              <h3>🛡️ Audit & Seal Verification</h3>
              <span className="security-tag verified">Tamper-Proof</span>
            </div>
            <p>Every cargo voyage is cryptographically hashed and linked to physical warehouse audits.</p>
            
            <div className="blockchain-seal-box">
              <span className="seal-icon">🔒</span>
              <div>
                <strong>Immutable Proof Hash</strong>
                <code className="seal-hash">0x70997970C51812dc3A010C7d01b50e0d17dc79C8</code>
                <small>Timestamped via CloudVoyage Audit Ledger</small>
              </div>
            </div>

            <div className="customer-actions">
              <button
                type="button"
                className="btn-download-manifest"
                onClick={() => alert(`Official Manifest for ${displayVoyage.referenceNumber || 'VOY-2026-041'} verified! All container seals match.`)}
              >
                📄 View Cargo Inspection Certificate
              </button>
            </div>
          </div>
        </div>

        {/* Owner Division Prompt Bar */}
        <div className="owner-switch-callout">
          <div>
            <h4>Are you an Operations Manager or Warehouse Auditor?</h4>
            <p>Switch to the Owner Division to access live inventory adjustments, voyage creation, and system telemetry.</p>
          </div>
          <button
            type="button"
            className="btn-switch-owner"
            onClick={onSwitchToOwner}
          >
            🏢 Access Owner / Admin Division →
          </button>
        </div>
      </div>
    </div>
  )
}

