export default function BoxLoader({ message = "Tracking logistics stream..." }) {
  return (
    <div className="box-loader-overlay">
      <div className="box-loader-container">
        <div className="cargo-box-wrapper">
          <div className="cargo-cube">
            <div className="cube-face cube-front">
              <span className="box-tape"></span>
              <span className="box-label">FRAGILE</span>
            </div>
            <div className="cube-face cube-back">
              <span className="box-barcode">||||||||||</span>
            </div>
            <div className="cube-face cube-right">
              <span className="box-stamp">AIR / SEA</span>
            </div>
            <div className="cube-face cube-left">
              <span className="box-arrows">▲▲</span>
            </div>
            <div className="cube-face cube-top">
              <span className="box-seal">✔ CLOUD</span>
            </div>
            <div className="cube-face cube-bottom"></div>
          </div>
          <div className="box-shadow"></div>
        </div>
        <p className="loader-text">{message}</p>
        <div className="loader-progress-bar">
          <div className="loader-progress-fill"></div>
        </div>
      </div>
    </div>
  )
}

