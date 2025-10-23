import React from 'react'
import { Button, Tabs, Input } from 'antd'

export default function App() {
  return (
    <div style={{ padding: 24 }}>
      <h1>BL4 Serial Toolkit</h1>
      <Tabs
        defaultActiveKey="1"
        items={[
          { key: '1', label: 'Decoder', children: <Input.TextArea placeholder="Paste serial here" rows={6} /> },
          { key: '2', label: 'Viewer',  children: <div>Viewer table goes here</div> },
          { key: '3', label: 'Editor',  children: <div>Editor form goes here</div> },
          { key: '4', label: 'Settings',children: <div>Settings go here</div> },
        ]}
      />
      <div style={{ marginTop: 16 }}>
        <Button type="primary">Run</Button>
      </div>
    </div>
  )
}
