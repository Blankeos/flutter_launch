import React, { type KeyboardEvent, useState } from 'react';
import { useNavigate } from 'react-router';

export const MiniAddressBar: React.FC = () => {
  const navigate = useNavigate();
  const [path, setPath] = useState('');

  const handleInputChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    setPath(event.target.value);
  };

  const handleKeyPress = (event: KeyboardEvent<HTMLInputElement>) => {
    if (event.key === 'nter') {
      navigate(path);
      setPath(''); // Clear input after navigation
    }
  };

  const containerStyle = {
    padding: '10px',
    borderBottom: '1px solid #eee',
    backgroundColor: '#f9f9f9',
    display: 'flex',
    alignItems: 'center',
  };

  const inputStyle = {
    flexGrow: 1,
    padding: '6px 10px',
    marginRight: '10px',
    border: '1px solid #ccc',
    borderRadius: '4px',
    fontSize: '14px',
  };

  const labelStyle = {
    marginRight: '8px',
    fontWeight: 'bold',
    fontSize: '14px',
  };

  return (
    <view style={containerStyle}>
      {/* <text style={labelStyle}>Path:</text>
      <input
        id="address-bar-input"
        type="text"
        value={path}
        onChange={handleInputChange}
        onKeyPress={handleKeyPress}
        placeholder="e.g., /about, /users/123"
        style={inputStyle}
      /> */}
    </view>
  );
};
