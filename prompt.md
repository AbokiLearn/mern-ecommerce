
<file name="./create-prompt.sh" format="sh">
#!/bin/bash

echo > prompt.md

find . -type f \
  ! -name 'SECURITY.md' \
  ! -name 'package-lock.json' \
  ! -name 'LICENSE' \
  ! -name 'content-plan-client.md' \
  ! -name 'compose.yml' \
  ! -name 'bun.lockb' \
  ! -name '.prettierignore' \
  ! -name '.gitignore' \
  ! -name '.env' \
  ! -path './server/*' \
  ! -path './node_modules/*' \
  ! -path './data/*' \
  ! -path './.vscode/*' \
  ! -path './.github/*' \
  ! -name '.babelrc' \
  ! -name 'vercel.json' \
  ! -path './client/public/images/*' \
  ! -path './.git/*' \
  ! -name 'prompt.md' | while read file; do
    echo "<file name=\"${file}\" format=\"$(basename "${file##*.}")\">" >> prompt.md
    cat "$file" >> prompt.md
    echo "</file>" >> prompt.md
done

</file>
<file name="./client/app/contexts/Socket/provider.js" format="js">
import React, { useState } from 'react';

import io from 'socket.io-client';

import SocketContext from './context';
import { SOCKET_URL } from '../../constants';

const SocketProvider = ({ children }) => {
  const [socket, setSocket] = useState(null);

  const connect = () => {
    const token = localStorage.getItem('token');
    const sk = io(SOCKET_URL, {
      autoConnect: false
    });

    if (token) {
      sk.auth = { token };
      sk.connect();
      sk.auth;
      setSocket(sk);
    }
  };

  const disconnect = () => {
    if (socket) {
      socket.close();
    }
  };

  return (
    <SocketContext.Provider value={{ socket, connect, disconnect }}>
      {children}
    </SocketContext.Provider>
  );
};

export default SocketProvider;
</file>
<file name="./client/app/contexts/Socket/index.js" format="js">
import SocketProvider from './provider';
import SocketContext from './context';
import useSocket from './useSocket';

export { SocketProvider, SocketContext, useSocket };
</file>
<file name="./client/app/contexts/Socket/useSocket.js" format="js">
import { useContext } from 'react';

import SocketContext from './context';

const useSocket = () => useContext(SocketContext);

export default useSocket;
</file>
<file name="./client/app/contexts/Socket/context.js" format="js">
import React from 'react';

const SocketContext = React.createContext();

export default SocketContext;
</file>
<file name="./client/app/components/Common/Footer/index.js" format="js">
/**
 *
 * Footer
 *
 */

import React from 'react';

import { Link } from 'react-router-dom';
import { Container } from 'reactstrap';

import Newsletter from '../../../containers/Newsletter';

const Footer = () => {
  const infoLinks = [
    { id: 0, name: 'Contact Us', to: '/contact' },
    { id: 1, name: 'Sell With Us', to: '/sell' },
    { id: 2, name: 'Shipping', to: '/shipping' }
  ];

  const footerBusinessLinks = (
    <ul className='support-links'>
      <li className='footer-link'>
        <Link to='/dashboard'>Account Details</Link>
      </li>
      <li className='footer-link'>
        <Link to='/dashboard/orders'>Orders</Link>
      </li>
    </ul>
  );

  const footerLinks = infoLinks.map(item => (
    <li key={item.id} className='footer-link'>
      <Link key={item.id} to={item.to}>
        {item.name}
      </Link>
    </li>
  ));

  return (
    <footer className='footer'>
      <Container>
        <div className='footer-content'>
          <div className='footer-block'>
            <div className='block-title'>
              <h3 className='text-uppercase'>Customer Service</h3>
            </div>
            <div className='block-content'>
              <ul>{footerLinks}</ul>
            </div>
          </div>
          <div className='footer-block'>
            <div className='block-title'>
              <h3 className='text-uppercase'>Links</h3>
            </div>
            <div className='block-content'>
              <ul>{footerLinks}</ul>
            </div>
          </div>
          <div className='footer-block'>
            <div className='block-title'>
              <h3 className='text-uppercase'>Newsletter</h3>
              <Newsletter />
            </div>
          </div>
        </div>
        <div className='footer-copyright'>
          <span>© {new Date().getFullYear()} MERN Store</span>
        </div>
        <ul className='footer-social-item'>
          <li>
            <a href='/#facebook' rel='noreferrer noopener' target='_blank'>
              <span className='facebook-icon' />
            </a>
          </li>
          <li>
            <a href='/#instagram' rel='noreferrer noopener' target='_blank'>
              <span className='instagram-icon' />
            </a>
          </li>
          <li>
            <a href='/#pinterest' rel='noreferrer noopener' target='_blank'>
              <span className='pinterest-icon' />
            </a>
          </li>
          <li>
            <a href='/#twitter' rel='noreferrer noopener' target='_blank'>
              <span className='twitter-icon' />
            </a>
          </li>
        </ul>
      </Container>
    </footer>
  );
};

export default Footer;
</file>
<file name="./client/app/components/Common/SelectOption/index.js" format="js">
/**
 *
 * SelectOption
 *
 */

import React from 'react';

import Select from 'react-select';
import makeAnimated from 'react-select/animated';

const SelectOption = props => {
  const {
    disabled,
    error,
    label,
    multi,
    options,
    defaultValue,
    value,
    handleSelectChange
  } = props;

  const _handleSelectChange = value => {
    handleSelectChange(value);
  };

  const animatedComponents = makeAnimated();

  const styles = `select-box${error ? ' invalid' : ''}`;

  return (
    <div className={styles}>
      {label && <label>{label}</label>}
      <Select
        isDisabled={disabled}
        className='select-container'
        classNamePrefix='react-select'
        components={animatedComponents}
        isMulti={multi}
        options={options}
        defaultValue={defaultValue}
        value={value}
        onChange={_handleSelectChange}
        styles={dropdownStyles}
      />
      <span className='invalid-message'>{error && error[0]}</span>
    </div>
  );
};

export default SelectOption;

const dropdownStyles = {
  control: (styles, { isFocused }) => {
    return {
      ...styles,
      color: '#323232',
      fontFamily: 'Poppins',
      backgroundColor: 'white',
      transition: '0.3s',
      boxShadow: 'none',

      borderColor: isFocused ? '#bdcbd2' : '#e4e6eb',

      ':hover': {
        borderColor: !isFocused ? '#e4e6eb' : '#bdcbd2',
        boxShadow: 'none'
      }
    };
  },
  menu: styles => {
    return {
      ...styles,
      zIndex: 2
    };
  },
  option: (styles, { isDisabled, isFocused, isSelected }) => {
    return {
      ...styles,
      color: '#323232',
      fontFamily: 'Poppins',
      backgroundColor: isDisabled
        ? undefined
        : isSelected
        ? '#eceef3'
        : isFocused
        ? '#f8f9fa'
        : undefined,

      ':hover': {
        ...styles[':hover'],
        backgroundColor: isDisabled
          ? undefined
          : isSelected
          ? undefined
          : '#f8f9fa'
      },
      ':active': {
        ...styles[':active'],
        backgroundColor: !isDisabled ? '#eceef3' : undefined
      }
    };
  },
  indicatorSeparator: styles => ({
    ...styles,
    display: 'none'
  }),
  dropdownIndicator: (base, { isFocused }) => ({
    ...base,
    transform: isFocused ? 'rotate(180deg)' : undefined,
    transition: 'transform 0.3s'
  }),
  input: styles => ({
    ...styles,
    color: '#323232'
  }),
  placeholder: styles => ({
    ...styles,
    color: '#323232'
  }),
  singleValue: styles => ({
    ...styles,
    color: '#323232',
    fontFamily: 'Poppins'
  })
};
</file>
<file name="./client/app/components/Common/SearchBar/index.js" format="js">
/**
 *
 * SearchBar
 *
 */

import React from 'react';

import Button from '../Button';

class SearchBar extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      value: '',
      typing: false,
      typingTimeout: 0
    };
  }

  _onChange(e) {
    const name = e.target.name;
    const value = e.target.value;

    if (this.state.typingTimeout) {
      clearTimeout(this.state.typingTimeout);
    }

    this.setState({
      value,
      typing: false,
      typingTimeout: setTimeout(() => {
        if (this.props.onSearch) {
          this.props.onSearch({ name, value });
        }
      }, 1000)
    });
  }

  _handleSubmit(e) {
    e.preventDefault();

    const name = this.props.name;
    const value = this.state.value;

    if (this.props.onSearchSubmit) {
      this.props.onSearchSubmit({ name, value });
    }
  }

  _onBlur(e) {
    const name = e.target.name;
    const value = e.target.value;

    if (this.props.onBlur) {
      this.props.onBlur({ name, value });
    }
  }

  render() {
    const {
      id,
      name,
      placeholder,
      className,
      inlineBtn,
      btnText,
      autoComplete
    } = this.props;
    const { value } = this.state;

    const styles = `search-box${inlineBtn ? ` inline-btn-box` : ''}`;
    const classNames = `input-text search-box${`${
      className && ` ${className}`
    }`}`;

    return (
      <form onSubmit={e => this._handleSubmit(e)} noValidate>
        <div className={styles}>
          <div className='input-text-block'>
            <input
              autoComplete={autoComplete}
              type='text'
              id={id}
              name={name}
              className={classNames}
              placeholder={placeholder}
              value={value}
              onChange={e => {
                this._onChange(e);
              }}
              onBlur={e => this._onBlur(e)}
              onKeyPress={this.props.onKeyPress || null}
            />
            <Button type='submit' variant='primary' text={btnText} />
          </div>
        </div>
      </form>
    );
  }
}

SearchBar.defaultProps = {
  className: '',
  id: 'search',
  name: 'search',
  placeholder: 'Search',
  inlineBtn: true,
  btnText: 'Search',
  autoComplete: 'off'
};

export default SearchBar;
</file>
<file name="./client/app/components/Common/CartIcon/index.js" format="js">
/**
 *
 * CartIcon
 *
 */

import React from 'react';

import { BagIcon } from '../Icon';
import Button from '../Button';

const CartIcon = props => {
  const { className, onClick, cartItems } = props;

  const Icon = (
    <span className='cart-icon'>
      <BagIcon />
      {cartItems.length > 0 && (
        <span className='cart-badge'>
          {cartItems.length >= 99 ? '99+' : cartItems.length}
        </span>
      )}
    </span>
  );

  const items = cartItems.length;

  return (
    <Button
      borderless
      variant='empty'
      className={className}
      ariaLabel={
        items > 0 ? `your cart have ${items} items` : 'your cart is empty'
      }
      icon={Icon}
      onClick={onClick}
    />
  );
};

export default CartIcon;
</file>
<file name="./client/app/components/Common/Tooltip/index.js" format="js">
/**
 *
 * Tooltip
 *
 */

import React from 'react';

import { UncontrolledTooltip } from 'reactstrap';

const Tooltip = props => {
  const { target, placement, children } = props;

  return (
    <UncontrolledTooltip placement={placement} target={target}>
      {children}
    </UncontrolledTooltip>
  );
};

Tooltip.defaultProps = {
  placement: 'top'
};

export default Tooltip;
</file>
<file name="./client/app/components/Common/Input/index.js" format="js">
/**
 *
 * Input
 *
 */

import React from 'react';
import ReactStars from 'react-rating-stars-component';

const Input = props => {
  const {
    autoComplete,
    type,
    value,
    error,
    step,
    decimals,
    min,
    max,
    disabled,
    placeholder,
    rows,
    label,
    name,
    onInputChange,
    inlineElement
  } = props;

  const _onChange = e => {
    if (e.target.name == 'image') {
      onInputChange(e.target.name, e.target.files[0]);
    } else {
      onInputChange(e.target.name, e.target.value);
    }
  };

  if (type === 'textarea') {
    const styles = `input-box${error ? ' invalid' : ''}`;

    return (
      <div className={styles}>
        {label && <label>{label}</label>}
        <textarea
          type={'textarea'}
          onChange={e => {
            _onChange(e);
          }}
          rows={rows}
          name={name}
          value={value}
          placeholder={placeholder}
          className={'textarea-text'}
        />
        <span className='invalid-message'>{error && error[0]}</span>
      </div>
    );
  } else if (type === 'number') {
    const styles = `input-box${error ? ' invalid' : ''}`;

    const handleOnInput = e => {
      if (!decimals) {
        e.target.value = e.target.value.replace(/[^0-9]*/g, '');
      }
    };
    return (
      <div className={styles}>
        {label && <label>{label}</label>}
        <input
          autoComplete={autoComplete}
          step='step'
          min={min || 0}
          max={max || null}
          pattern='[0-9]'
          onInput={handleOnInput}
          type={type}
          onChange={e => {
            _onChange(e);
          }}
          disabled={disabled}
          name={name}
          value={value}
          placeholder={placeholder}
          className={'input-number'}
        />
        <span className='invalid-message'>{error && error[0]}</span>
      </div>
    );
  } else if (type === 'stars') {
    const styles = `input-box${error ? ' invalid' : ''}`;

    return (
      <div className={styles}>
        {label && <label>{label}</label>}
        <ReactStars
          name={name}
          starCount={5}
          size={30}
          color={'#adb5bd'}
          activeColor={'#ffb302'}
          a11y={true}
          isHalf={false}
          emptyIcon={<i className='fa fa-star' />}
          halfIcon={<i className='fa fa-star-half-alt' />}
          filledIcon={<i className='fa fa-star' />}
          value={value}
          onChange={value => {
            onInputChange(name, value);
          }}
        />
        <span className='invalid-message'>{error && error[0]}</span>
      </div>
    );
  } else {
    const styles = `input-box${inlineElement ? ` inline-btn-box` : ''} ${
      error ? 'invalid' : ''
    }`;

    return (
      <div className={styles}>
        {label && <label>{label}</label>}
        <div className='input-text-block'>
          <input
            className={'input-text'}
            autoComplete={autoComplete}
            type={type}
            onChange={e => {
              _onChange(e);
            }}
            disabled={disabled}
            name={name}
            value={value}
            placeholder={placeholder}
          />
          {inlineElement}
        </div>
        <span className='invalid-message'>{error && error[0]}</span>
      </div>
    );
  }
};

Input.defaultProps = {
  step: 1,
  decimals: true,
  rows: '4',
  inlineElement: null,
  autoComplete: 'on'
};

export default Input;
</file>
<file name="./client/app/components/Common/Button/index.js" format="js">
/**
 *
 * Button
 *
 */

import React from 'react';

import Tooltip from '../Tooltip';
import Popover from '../Popover';

const variants = {
  primary: 'custom-btn-primary',
  secondary: 'custom-btn-secondary',
  danger: 'custom-btn-danger',
  link: 'custom-btn-link',
  dark: 'custom-btn-dark',
  none: 'custom-btn-none',
  empty: ''
};

const Button = props => {
  const {
    id,
    size,
    variant,
    tabIndex,
    ariaLabel,
    ariaExpanded,
    type,
    disabled,
    className,
    text,
    role,
    icon,
    iconDirection,
    iconClassName,
    borderless,
    round,
    onClick,
    tooltip,
    tooltipContent,
    popover,
    popoverContent,
    popoverTitle
  } = props;

  const v = variant ? variants[variant] : '';

  const btnVariant = v;

  const btn =
    icon && text ? 'with-icon' : icon && !text ? 'icon-only' : 'text-only';

  const classNames = `input-btn${`${className && ` ${className}`}`}${
    btnVariant && ` ${btnVariant}`
  }${` ${size}`} ${btn} ${
    iconDirection === 'left' ? 'icon-left' : 'icon-right'
  } ${borderless ? 'border-0' : ''}`;

  const iconClassNames = `btn-icon${`${iconClassName && ` ${iconClassName}`}`}`;

  const tooltipId = tooltip ? `tooltip-${id}` : id;
  const popoverId = popover ? `popover-${id}` : id;
  const btnId = tooltip ? tooltipId : popoverId;

  return (
    <button
      id={btnId}
      tabIndex={tabIndex}
      aria-label={ariaLabel}
      aria-expanded={ariaExpanded}
      role={role}
      disabled={disabled}
      className={classNames}
      type={type}
      onClick={onClick}
      style={{
        borderRadius: round
      }}
    >
      {tooltip && <Tooltip target={tooltipId}>{tooltipContent}</Tooltip>}
      {popover && (
        <Popover target={popoverId} popoverTitle={popoverTitle}>
          {popoverContent}
        </Popover>
      )}
      {iconDirection === 'left' ? (
        <>
          {icon && <div className={iconClassNames}>{icon}</div>}
          {text && <span className='btn-text'>{text}</span>}
        </>
      ) : (
        <>
          {text && <span className='btn-text'>{text}</span>}
          {icon && <div className={iconClassNames}>{icon}</div>}
        </>
      )}
    </button>
  );
};

Button.defaultProps = {
  type: 'button',
  variant: 'secondary',
  size: 'md',
  className: '',
  iconDirection: 'left',
  iconClassName: '',
  borderless: false,
  round: 3,
  tooltip: false,
  popover: false
};

export default Button;
</file>
<file name="./client/app/components/Common/Popover/index.js" format="js">
/**
 *
 * Popover
 *
 */

import React from 'react';

import { UncontrolledPopover, PopoverHeader, PopoverBody } from 'reactstrap';

const Popover = props => {
  const { target, placement, popoverTitle, children } = props;

  return (
    <UncontrolledPopover placement={placement} target={target} trigger='legacy'>
      {popoverTitle && <PopoverHeader>{popoverTitle}</PopoverHeader>}
      <PopoverBody>{children}</PopoverBody>
    </UncontrolledPopover>
  );
};

Popover.defaultProps = {
  placement: 'top'
};

export default Popover;
</file>
<file name="./client/app/components/Common/Switch/index.js" format="js">
/**
 *
 * Switch
 *
 */

import React from 'react';

import Tooltip from '../Tooltip';

class Switch extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      checked: this.props.checked
    };
  }

  componentDidUpdate(prevProps) {
    if (prevProps.checked !== this.props.checked) {
      this.setState({
        checked: this.props.checked
      });
    }
  }

  _onChange(e) {
    const value = e.target.checked;

    this.setState({
      checked: value
    });

    if (this.props.toggleCheckboxChange) {
      this.props.toggleCheckboxChange(value);
    }
  }

  render() {
    const { className, style, id, label, tooltip, tooltipContent } = this.props;
    const { checked } = this.state;

    const tooltipId = `tooltip-${id}`;

    const classNames = `switch-checkbox${`${className && ` ${className}`}`}`;

    return (
      <div className={classNames} id={tooltipId} style={style}>
        {tooltip && <Tooltip target={tooltipId}>{tooltipContent}</Tooltip>}
        <input
          id={id}
          type={'checkbox'}
          className='switch-checkbox-input'
          checked={checked}
          onChange={e => this._onChange(e)}
        />
        <label htmlFor={id} className='switch-label'>
          {label && <span className='switch-label-text'>{label} </span>}
          <span className='switch-label-toggle'></span>
        </label>
      </div>
    );
  }
}

Switch.defaultProps = {
  className: ''
};

export default Switch;
</file>
<file name="./client/app/components/Common/DropdownConfirm/index.js" format="js">
/**
 *
 * DropdownConfirm
 *
 */

import React from 'react';

import {
  UncontrolledButtonDropdown,
  DropdownMenu,
  DropdownToggle
} from 'reactstrap';

const DropdownConfirm = props => {
  const { className, label, children } = props;

  return (
    <div className={`dropdown-confirm ${className}`}>
      <UncontrolledButtonDropdown>
        <DropdownToggle nav>
          <div className='dropdown-action sm'>
            {label}
            <span className='fa fa-chevron-down dropdown-caret'></span>
          </div>
        </DropdownToggle>
        <DropdownMenu right>{children}</DropdownMenu>
      </UncontrolledButtonDropdown>
    </div>
  );
};

DropdownConfirm.defaultProps = {
  label: ''
};

export default DropdownConfirm;
</file>
<file name="./client/app/components/Common/Page404/index.js" format="js">
/**
 *
 * Page404
 *
 */

import React from 'react';

const Page404 = () => {
  return (
    <div className='page-404'>The page you are looking for was not found.</div>
  );
};

export default Page404;
</file>
<file name="./client/app/components/Common/Icon/index.js" format="js">
/**
 *
 * Icon
 *
 */

import React from 'react';

const BagIcon = () => {
  return (
    <svg
      aria-hidden='true'
      className='bag-icon'
      version='1.1'
      xmlns='http://www.w3.org/2000/svg'
      viewBox='0 0 512 512'
      enableBackground='new 0 0 512 512'
    >
      <g>
        <path d='m417.9,104.4h-65.5c-2.2-51-44.8-92.4-96.4-92.4s-94.2,41.3-96.5,92.4h-66.5l-30.1,395.6h386.2l-31.2-395.6zm-161.9-71.6c40.1,0 73.5,32 75.7,71.6h-151.4c2.2-39.6 35.6-71.6 75.7-71.6zm-143.3,92.4h46.7v68.5h20.8v-68.5h151.6v68.5h20.8v-68.5h47.8l27,354h-341.7l27-354z' />
      </g>
    </svg>
  );
};

const BarsIcon = () => {
  return <span className='bars-icon fa fa-bars' aria-hidden='true' />;
};

const CloseIcon = () => {
  return <span className='close-icon' aria-hidden='true' />;
};

const GoogleIcon = () => {
  return (
    <svg
      className='google-icon'
      xmlns='http://www.w3.org/2000/svg'
      viewBox='0 0 533.5 544.3'
    >
      <path
        fill='#4285f4'
        d='M533.5 278.4c0-18.5-1.5-37.1-4.7-55.3H272.1v104.8h147c-6.1 33.8-25.7 63.7-54.4 82.7v68h87.7c51.5-47.4 81.1-117.4 81.1-200.2z'
      />
      <path
        fill='#34a853'
        d='M272.1 544.3c73.4 0 135.3-24.1 180.4-65.7l-87.7-68c-24.4 16.6-55.9 26-92.6 26-71 0-131.2-47.9-152.8-112.3H28.9v70.1c46.2 91.9 140.3 149.9 243.2 149.9z'
      />
      <path
        fill='#fbbc04'
        d='M119.3 324.3c-11.4-33.8-11.4-70.4 0-104.2V150H28.9c-38.6 76.9-38.6 167.5 0 244.4l90.4-70.1z'
      />
      <path
        fill='#ea4335'
        d='M272.1 107.7c38.8-.6 76.3 14 104.4 40.8l77.7-77.7C405 24.6 339.7-.8 272.1 0 169.2 0 75.1 58 28.9 150l90.4 70.1c21.5-64.5 81.8-112.4 152.8-112.4z'
      />
    </svg>
  );
};

const FacebookIcon = () => {
  return (
    <svg
      className='facebook-icon'
      fill='#3b5998'
      xmlns='http://www.w3.org/2000/svg'
      width='24'
      height='24'
      viewBox='0 0 24 24'
    >
      <path d='M22.675 0H1.325C.593 0 0 .593 0 1.325v21.351C0 23.407.593 24 1.325 24H12.82v-9.294H9.692v-3.622h3.128V8.413c0-3.1 1.893-4.788 4.659-4.788 1.325 0 2.463.099 2.795.143v3.24l-1.918.001c-1.504 0-1.795.715-1.795 1.763v2.313h3.587l-.467 3.622h-3.12V24h6.116c.73 0 1.323-.593 1.323-1.325V1.325C24 .593 23.407 0 22.675 0z' />
    </svg>
  );
};

const CheckIcon = ({
  className = '',
  color = 'currentColor',
  width = '24',
  height = '24'
}) => {
  return (
    <svg
      className={`${className} check-icon`}
      xmlns='http://www.w3.org/2000/svg'
      width={width}
      height={height}
      viewBox='0 0 24 24'
      fill='none'
      stroke={color}
      strokeWidth='2'
      strokeLinecap='round'
      strokeLinejoin='round'
    >
      <path d='M22 11.08V12a10 10 0 1 1-5.93-9.14' />
      <polyline points='22 4 12 14.01 9 11.01' />
    </svg>
  );
};

const RefreshIcon = ({ className = '', width = '20', height = '20' }) => {
  return (
    <svg
      className={`${className} refresh-icon`}
      xmlns='http://www.w3.org/2000/svg'
      width={width}
      height={height}
      viewBox='0 0 24 24'
      fill='none'
      stroke='currentColor'
      strokeWidth='2'
      strokeLinecap='round'
      strokeLinejoin='round'
    >
      <polyline points='23 4 23 10 17 10' />
      <polyline points='1 20 1 14 7 14' />
      <path d='M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15' />
    </svg>
  );
};

const AddressIcon = ({ className = '', width = '20', height = '20' }) => {
  return (
    <svg
      className={`${className} address-icon`}
      enableBackground='new 0 0 512 512'
      width={width}
      height={height}
      viewBox='0 0 512 512'
      xmlns='http://www.w3.org/2000/svg'
    >
      <g>
        <path
          d='m470.793 489.077h-195.735v-109.064l97.868-88.713 97.867 88.713z'
          fill='#f8f7f7'
        />
        <path d='m439.887 351.998v137.079h30.906v-109.064z' fill='#efefef' />
        <path
          d='m411.042 489.203h-76.233v-73.01c0-21.051 17.065-38.117 38.117-38.117 21.051 0 38.117 17.065 38.117 38.117v73.01z'
          fill='#686169'
        />
        <path
          d='m233.9 117.204c0 104.853-105.051 201.285-116.95 201.285s-116.95-96.432-116.95-201.285c0-64.73 52.36-117.204 116.95-117.204s116.95 52.474 116.95 117.204z'
          fill='#ff6167'
        />
        <path
          d='m116.95 0c-5.239 0-10.396.351-15.453 1.02 57.285 7.579 101.497 56.704 101.497 116.184 0 84.985-69.009 164.433-101.497 191.491 7.595 6.325 13.198 9.794 15.453 9.794 11.899 0 116.95-96.432 116.95-201.285 0-64.73-52.36-117.204-116.95-117.204z'
          fill='#fe454a'
        />
        <circle cx='116.95' cy='117.204' fill='#f8f7f7' r='79.324' />
        <path
          d='m116.95 37.88c-5.287 0-10.452.531-15.453 1.522 36.366 7.211 63.871 39.35 63.871 77.802s-27.505 70.591-63.871 77.802c5.001.991 10.165 1.522 15.453 1.522 43.739 0 79.324-35.585 79.324-79.324s-35.584-79.324-79.324-79.324z'
          fill='#efefef'
        />
        <path
          d='m504.92 386.251-121.562-111.259c-5.903-5.405-14.962-5.405-20.865 0l-121.561 111.259c-6.296 5.762-6.728 15.536-.967 21.832 5.763 6.295 15.538 6.727 21.832.966l111.129-101.711 111.129 101.711c2.965 2.714 6.702 4.054 10.429 4.054 4.184 0 8.355-1.69 11.403-5.02 5.761-6.296 5.328-16.07-.967-21.832z'
          fill='#ff6167'
        />
        <g fill='#7b727b'>
          <path d='m209.033 445.186h-28.606c-4.143 0-7.5 3.358-7.5 7.5s3.357 7.5 7.5 7.5h28.606c4.143 0 7.5-3.358 7.5-7.5s-3.357-7.5-7.5-7.5z' />
          <path d='m154.118 445.186h-17.687c-6.606 0-11.981-5.375-11.981-11.982v-24.473c0-4.142-3.357-7.5-7.5-7.5s-7.5 3.358-7.5 7.5v24.473c0 14.878 12.104 26.982 26.981 26.982h17.687c4.143 0 7.5-3.358 7.5-7.5s-3.357-7.5-7.5-7.5z' />
          <path d='m116.95 389.816c4.143 0 7.5-3.358 7.5-7.5v-26.476c0-4.142-3.357-7.5-7.5-7.5s-7.5 3.358-7.5 7.5v26.476c0 4.142 3.358 7.5 7.5 7.5z' />
        </g>
        <path
          d='m496.547 512h-247.243c-8.534 0-15.453-6.918-15.453-15.453 0-8.534 6.918-15.453 15.453-15.453h247.243c8.534 0 15.453 6.918 15.453 15.453 0 8.535-6.918 15.453-15.453 15.453z'
          fill='#e07f5d'
        />
        <path
          d='m496.547 481.095h-30.905c8.534 0 15.453 6.919 15.453 15.453s-6.919 15.453-15.453 15.453h30.905c8.534 0 15.453-6.919 15.453-15.453 0-8.535-6.919-15.453-15.453-15.453z'
          fill='#d06d4a'
        />
      </g>
    </svg>
  );
};

const ReviewIcon = ({ className = '', width = '60', height = '60' }) => {
  return (
    <svg
      className={`${className} review-icon`}
      enableBackground='new 0 0 512 512'
      width={width}
      height={height}
      viewBox='0 0 512 512'
      xmlns='http://www.w3.org/2000/svg'
    >
      <g>
        <path
          d='m151.632 106h-45.632-44.604l-30.396 15v255l28.658 15h46.342 60l15-15v-255z'
          fill='#ffdf40'
        />
        <path d='m181 376v-255l-29.368-15h-45.632v285h60z' fill='#ffbe40' />
        <path
          d='m436 61h-90-90c-24.814 0-45 20.186-45 45v120c0 24.814 20.186 45 45 45h15v45c0 6.064 3.647 11.543 9.258 13.857 5.533 2.309 12.023 1.071 16.348-3.252l49.394-49.394 6.211-6.211h83.789c24.814 0 45-20.186 45-45v-120c0-24.814-20.186-45-45-45z'
          fill='#7ed96c'
        />
        <path
          d='m436 271c24.814 0 45-20.186 45-45v-120c0-24.814-20.186-45-45-45h-90v216.211l6.211-6.211z'
          fill='#48b348'
        />
        <path d='m106 106h-15v300h15 15v-300z' fill='#ffbe40' />
        <path d='m106 106h15v300h-15z' fill='#ff9f40' />
        <path
          d='m386.605 140.395c-5.859-5.859-15.352-5.859-21.211 0l-19.394 19.394-15 15-11.895-11.895c-5.859-5.859-15.352-5.859-21.211 0s-5.859 15.352 0 21.211l22.5 22.5c2.93 2.93 6.768 4.395 10.605 4.395s7.676-1.465 10.605-4.395l4.395-4.395 40.605-40.605c5.861-5.859 5.861-15.351.001-21.21z'
          fill='#f9f4f3'
        />
        <path
          d='m386.605 140.395c-5.859-5.859-15.352-5.859-21.211 0l-19.394 19.394v42.422l40.605-40.605c5.86-5.86 5.86-15.352 0-21.211z'
          fill='#f0e6e1'
        />
        <path
          d='m166 0h-60-60c-8.291 0-15 6.709-15 15v76l25.421 15h49.579 45.632l29.368-15v-76c0-8.291-6.709-15-15-15z'
          fill='#ff6673'
        />
        <path
          d='m181 91v-76c0-8.291-6.709-15-15-15h-60v106h45.632z'
          fill='#e62e2e'
        />
        <path
          d='m106 376h-75c0 2.329.542 4.629 1.582 6.709l60 121c2.549 5.083 7.734 8.291 13.418 8.291s10.869-3.208 13.418-8.291l60-121c1.04-2.08 1.582-4.38 1.582-6.709z'
          fill='#ffebdc'
        />
        <path
          d='m119.418 503.709 60-121c1.04-2.08 1.582-4.38 1.582-6.709h-75v136c5.684 0 10.869-3.208 13.418-8.291z'
          fill='#ffd2c8'
        />
        <path d='m106 91h-75v30h75 75v-30z' fill='#4d6699' />
        <path d='m106 91h75v30h-75z' fill='#404b80' />
      </g>
    </svg>
  );
};

const TrashIcon = ({ className = '', width = '20', height = '20' }) => {
  return (
    <svg
      className={`${className} trash-icon`}
      xmlns='http://www.w3.org/2000/svg'
      width={width}
      height={height}
      viewBox='0 0 24 24'
      fill='none'
      stroke='currentColor'
      strokeWidth='2'
      strokeLinecap='round'
      strokeLinejoin='round'
    >
      <polyline points='3 6 5 6 21 6' />
      <path d='M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2' />
    </svg>
  );
};

const XIcon = ({ className = '', width = '20', height = '20' }) => {
  return (
    <svg
      className={`${className} x-icon`}
      xmlns='http://www.w3.org/2000/svg'
      width={width}
      height={height}
      viewBox='0 0 24 24'
      fill='none'
      stroke='currentColor'
      strokeWidth='2'
      strokeLinecap='round'
      strokeLinejoin='round'
    >
      <line x1='18' y1='6' x2='6' y2='18' />
      <line x1='6' y1='6' x2='18' y2='18' />
    </svg>
  );
};

const HeartIcon = ({ className = '' }) => {
  return (
    <svg
      className={`${className} heart-icon`}
      enableBackground='new 467 392 58 57'
      viewBox='467 392 58 57'
      xmlns='http://www.w3.org/2000/svg'
    >
      <g
        id='Group'
        fill='none'
        fillRule='evenodd'
        transform='translate(467 392)'
      >
        <path
          d='M29.144 20.773c-.063-.13-4.227-8.67-11.44-2.59C7.63 28.795 28.94 43.256 29.143 43.394c.204-.138 21.513-14.6 11.44-25.213-7.214-6.08-11.377 2.46-11.44 2.59z'
          id='heart'
          fill='#AAB8C2'
        />
        <circle
          id='main-circ'
          fill='#E2264D'
          opacity='0'
          cx='29.5'
          cy='29.5'
          r='1.5'
        />

        <g id='grp7' opacity='0' transform='translate(7 6)'>
          <circle id='oval1' fill='#FF6347' cx='2' cy='6' r='2' />
          <circle id='oval2' fill='#FF4500' cx='5' cy='2' r='2' />
        </g>

        <g id='grp6' opacity='0' transform='translate(0 28)'>
          <circle id='oval1' fill='#FF6347' cx='2' cy='7' r='2' />
          <circle id='oval2' fill='#FF4500' cx='3' cy='2' r='2' />
        </g>

        <g id='grp3' opacity='0' transform='translate(52 28)'>
          <circle id='oval2' fill='#FF6347' cx='2' cy='7' r='2' />
          <circle id='oval1' fill='#FF4500' cx='4' cy='2' r='2' />
        </g>

        <g id='grp2' opacity='0' transform='translate(44 6)'>
          <circle id='oval2' fill='#FF6347' cx='5' cy='6' r='2' />
          <circle id='oval1' fill='#FF4500' cx='2' cy='2' r='2' />
        </g>

        <g id='grp5' opacity='0' transform='translate(14 50)'>
          <circle id='oval1' fill='#FFA500' cx='6' cy='5' r='2' />
          <circle id='oval2' fill='#FF6347' cx='2' cy='2' r='2' />
        </g>

        <g id='grp4' opacity='0' transform='translate(35 50)'>
          <circle id='oval1' fill='#FFA500' cx='6' cy='5' r='2' />
          <circle id='oval2' fill='#FF6347' cx='2' cy='2' r='2' />
        </g>

        <g id='grp1' opacity='0' transform='translate(24)'>
          <circle id='oval1' fill='#FFA500' cx='2.5' cy='3' r='2' />
          <circle id='oval2' fill='#FF6347' cx='7.5' cy='2' r='2' />
        </g>
      </g>
    </svg>
  );
};

const ArrowBackIcon = ({ className = '', width = '20', height = '20' }) => {
  return (
    <svg
      className={`${className} arrow-left-icon`}
      xmlns='http://www.w3.org/2000/svg'
      width={width}
      height={height}
      viewBox='0 0 24 24'
      fill='none'
      stroke='currentColor'
      strokeWidth='2'
      strokeLinecap='round'
      strokeLinejoin='round'
    >
      <line x1='19' y1='12' x2='5' y2='12' />
      <polyline points='12 19 5 12 12 5' />
    </svg>
  );
};

export {
  BagIcon,
  BarsIcon,
  CloseIcon,
  GoogleIcon,
  FacebookIcon,
  CheckIcon,
  RefreshIcon,
  AddressIcon,
  ReviewIcon,
  TrashIcon,
  HeartIcon,
  XIcon,
  ArrowBackIcon
};
</file>
<file name="./client/app/components/Common/SignupProvider/index.js" format="js">
/**
 *
 * SignupProvider
 *
 */

import React from 'react';

import { GoogleIcon, FacebookIcon } from '../Icon';
import { API_URL } from '../../../constants';

const SignupProvider = () => {
  return (
    <div className='signup-provider'>
      <a href={`${API_URL}/auth/google`} className='mb-2 google-btn'>
        <GoogleIcon />
        <span className='btn-text'>Login with Google</span>
      </a>

      <a href={`${API_URL}/auth/facebook`} className='facebook-btn'>
        <FacebookIcon />
        <span className='btn-text'>Login with Facebook</span>
      </a>
    </div>
  );
};

export default SignupProvider;
</file>
<file name="./client/app/components/Common/LoadingIndicator/index.js" format="js">
/**
 *
 * LoadingIndicator
 *
 */

import React from 'react';

const LoadingIndicator = props => {
  const { inline, backdrop } = props;

  return (
    <div
      className={`spinner-container${
        inline ? ' position-relative' : ' position-fixed overlay'
      } ${backdrop ? 'backdrop' : ''}`}
    >
      <div
        className={`spinner${
          inline ? ' position-relative' : ' position-fixed overlay'
        }`}
      ></div>
    </div>
  );
};

LoadingIndicator.defaultProps = {
  inline: false,
  backdrop: false
};

export default LoadingIndicator;
</file>
<file name="./client/app/components/Common/Radio/index.js" format="js">
/**
 *
 * Checkbox
 *
 */

import React from 'react';

class Radio extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      size: ''
    };

    this.handleChange = this.handleChange.bind(this);
  }

  handleChange(event) {
    this.setState({
      size: event.target.value
    });
    this.props.handleChangeSubmit(event.target.name,event.target.value);
  }

  render() {
    return (
      <div>
        <ul>
          <li>
            <label>
              <input
                name="sorting"
                type="radio"
                value="Newest First"
                checked={this.state.size === "Newest First"}
                onChange={this.handleChange}
              />
              Newest First
            </label>
          </li>

          <li>
            <label>
              <input
                name="sorting"
                type="radio"
                value="Price High to Low"
                checked={this.state.size === "Price High to Low"}
                onChange={this.handleChange}
              />
              Price High to Low
            </label>
          </li>

          <li>
            <label>
              <input
                name="sorting"
                type="radio"
                value="Price Low to High"
                checked={this.state.size === "Price Low to High"}
                onChange={this.handleChange}
              />
              Price Low to High
            </label>
          </li>
        </ul>
      </div>
    );
  }
}

export default Radio;
</file>
<file name="./client/app/components/Common/Badge/index.js" format="js">
/**
 *
 * Badge
 *
 */

import React from 'react';

const variants = {
  primary: 'custom-badge-primary',
  secondary: 'custom-badge-secondary',
  danger: 'custom-badge-danger',
  dark: 'custom-badge-dark',
  none: 'custom-badge-none',
  empty: ''
};

const Badge = props => {
  const { variant, className, borderless, round, children } = props;

  const v = variant ? variants[variant] : '';

  const badgeVariant = v;

  const classNames = `custom-badge${`${className && ` ${className}`}`}${
    badgeVariant && ` ${badgeVariant}`
  }`;

  return (
    <span
      className={classNames}
      style={{
        borderRadius: borderless ? 0 : round
      }}
    >
      {children}
    </span>
  );
};

Badge.defaultProps = {
  variant: 'secondary',
  className: '',
  borderless: false,
  round: 3
};

export default Badge;
</file>
<file name="./client/app/components/Common/ComingSoon/index.js" format="js">
/**
 *
 * ComingSoon
 *
 */

import React from 'react';

const ComingSoon = props => {
  return (
    <div className='coming-soon'>
      <h3>Coming soon</h3>
      {props.children}
    </div>
  );
};

export default ComingSoon;
</file>
<file name="./client/app/components/Common/Table/index.js" format="js">
/**
 *
 * Table
 *
 */

import React from 'react';

import BootstrapTable from 'react-bootstrap-table-next';
import ToolkitProvider, {
  CSVExport,
  Search
} from 'react-bootstrap-table2-toolkit';

const indication = () => {
  return 'Oops! No data now! Please try again!';
};

const { ExportCSVButton } = CSVExport;
const { SearchBar } = Search;

const Table = props => {
  const {
    data,
    columns,
    striped,
    hover,
    condensed,
    csv,
    search,
    clickAction,
    isRowEvents
  } = props;

  const rowEvents = {
    onClick: (e, row, rowIndex) => {
      clickAction(row._id, rowIndex);
    }
  };

  return (
    <ToolkitProvider
      keyField='_id'
      data={data}
      columns={columns}
      exportCSV={csv}
      search={search}
    >
      {props => (
        <div className='table-section'>
          {csv && (
            <div className='csv'>
              <ExportCSVButton
                className='input-btn custom-btn-secondary md'
                {...props.csvProps}
              >
                Export CSV
              </ExportCSVButton>
            </div>
          )}
          {search && (
            <div className='search'>
              <SearchBar {...props.searchProps} />
            </div>
          )}
          <BootstrapTable
            {...props.baseProps}
            keyField='_id'
            data={data}
            columns={columns}
            striped={striped}
            hover={hover}
            condensed={condensed}
            noDataIndication={indication}
            // rowEvents={isRowEvents ? rowEvents : null}
          />
        </div>
      )}
    </ToolkitProvider>
  );
};

export default Table;
</file>
<file name="./client/app/components/Common/Checkbox/index.js" format="js">
/**
 *
 * Checkbox
 *
 */

import React, { useEffect, useState } from 'react';

const Checkbox = props => {
  const { className, id, name, label, disabled, checked, onChange } = props;
  const [isChecked, setIsChecked] = useState(checked);

  useEffect(() => {
    setIsChecked(checked);
  }, [checked]);

  const _onChange = e => {
    setIsChecked(!isChecked);

    const value = e.target.checked;
    const name = e.target.name;
    onChange(name, value);
  };

  const isLabelText = label && typeof label === 'string';
  const extraClassName = isLabelText
    ? ` default-icon ${className}`
    : ` custom-icon ${className}`;

  return (
    <div className={`checkbox${extraClassName}`}>
      <input
        className={'input-checkbox'}
        type={'checkbox'}
        id={id}
        name={name}
        checked={!disabled ? isChecked : false}
        onChange={_onChange}
      />
      <label htmlFor={id} type='submit'>
        {isLabelText ? label : label}
      </label>
    </div>
  );
};

export default Checkbox;

Checkbox.defaultProps = {
  className: ''
};
</file>
<file name="./client/app/components/Common/Pagination/index.js" format="js">
/**
 *
 * Pagination
 *
 */

import React from 'react';
import ReactPaginate from 'react-paginate';

const Pagination = props => {
  const { totalPages, onPagination } = props;

  const handlePageClick = event => {
    onPagination('pagination', event.selected + 1);
  };

  return (
    <div className='pagination-box'>
      <ReactPaginate
        nextLabel='next >'
        onPageChange={handlePageClick}
        pageRangeDisplayed={3}
        marginPagesDisplayed={2}
        pageCount={totalPages} // The total number of pages.
        previousLabel='< previous'
        pageClassName='page-item'
        pageLinkClassName='page-link'
        previousClassName='page-item'
        previousLinkClassName='page-link'
        nextClassName='page-item'
        nextLinkClassName='page-link'
        breakLabel='...'
        breakClassName='page-item'
        breakLinkClassName='page-link'
        containerClassName='pagination'
        activeClassName='active'
        renderOnZeroPageCount={null}
      />
    </div>
  );
};

export default Pagination;
</file>
<file name="./client/app/components/Common/NotFound/index.js" format="js">
/**
 *
 * NotFound
 *
 */

import React from 'react';

const NotFound = props => {
  const { message, className, children } = props;
  return (
    <div className={`not-found ${className}`}>
      {message ? message : children}
    </div>
  );
};

NotFound.defaultProps = {
  className: ''
};

export default NotFound;
</file>
<file name="./client/app/components/Common/RangeSlider/index.js" format="js">
/**
 *
 *  Range Slider
 *
 */

import React from 'react';
import Slider, { SliderTooltip } from 'rc-slider';

const { createSliderWithTooltip } = Slider;
const Range = createSliderWithTooltip(Slider.Range);
const { Handle } = Slider;

const handle = props => {
  const { value, dragging, index, ...restProps } = props;
  return (
    <SliderTooltip
      prefixCls='rc-slider-tooltip'
      overlay={`$${value}`}
      visible={dragging}
      placement='top'
      key={index}
    >
      <Handle value={value} {...restProps} />
    </SliderTooltip>
  );
};

class RangeSlider extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      sliderValue: 50,
      rangeValue: this.props.defaultValue
    };
  }

  onSliderChange = v => {
    this.setState({
      sliderValue: v
    });
  };

  onRangeChange = v => {
    this.setState({
      rangeValue: v
    });
  };

  onAfterSliderChange = value => {
    this.props.onChange(value);
  };

  onAfterRangeChange = value => {
    this.props.onChange(value);
  };

  render() {
    const { type, marks, step, defaultValue, max, allowCross } = this.props;
    const { sliderValue, rangeValue } = this.state;

    return (
      <>
        {type === 'slider' ? (
          <Slider
            className='slider'
            dots
            reverse
            allowCross={allowCross}
            step={step}
            defaultValue={defaultValue}
            marks={marks}
            value={sliderValue}
            onChange={this.onSliderChange}
            onAfterChange={this.onAfterSliderChange}
          />
        ) : (
          <Range
            className='slider'
            pushable={10}
            allowCross={allowCross}
            min={1}
            max={max}
            step={step}
            defaultValue={defaultValue}
            marks={marks}
            handle={handle}
            tipFormatter={value => `$${value}`}
            value={rangeValue}
            onChange={this.onRangeChange}
            onAfterChange={this.onAfterRangeChange}
          />
        )}
      </>
    );
  }
}

RangeSlider.defaultProps = {
  type: 'range',
  allowCross: true
};

export default RangeSlider;
</file>
<file name="./client/app/components/Common/CarouselSlider/index.js" format="js">
/**
 *
 * Carousel
 *
 */

import React from 'react';

import Carousel from 'react-multi-carousel';
import 'react-multi-carousel/lib/styles.css';

const CarouselSlider = props => {
  const {
    swipeable,
    draggable,
    showDots,
    infinite,
    autoPlay,
    keyBoardControl,
    autoPlaySpeed,
    ssr,
    responsive,
    children
  } = props;

  return (
    <Carousel
      swipeable={swipeable}
      draggable={draggable}
      showDots={showDots}
      infinite={infinite}
      autoPlay={autoPlay}
      keyBoardControl={keyBoardControl}
      autoPlaySpeed={autoPlaySpeed}
      ssr={ssr}
      responsive={responsive}
      customTransition='all 1s'
      transitionDuration={500}
      containerClass='carousel-container'
      dotListClass='carousel-dot-list-style'
      itemClass='carousel-slider-item'
    >
      {children}
    </Carousel>
  );
};

CarouselSlider.defaultProps = {
  swipeable: false,
  draggable: false,
  showDots: false,
  infinite: true,
  autoPlay: false,
  keyBoardControl: true,
  ssr: false,
  autoPlaySpeed: 2000
};

export default CarouselSlider;
</file>
<file name="./client/app/components/Common/CarouselSlider/utils.js" format="js">
export const responsiveOneItemCarousel = {
  desktop: {
    breakpoint: {
      max: 3000,
      min: 1024
    },
    items: 1,
    slidesToSlide: 1,
    partialVisibilityGutter: 0
  },
  mobile: {
    breakpoint: {
      max: 464,
      min: 0
    },
    items: 1,
    slidesToSlide: 1,
    partialVisibilityGutter: 0
  },
  tablet: {
    breakpoint: {
      max: 1024,
      min: 200
    },
    items: 1,
    slidesToSlide: 1,
    partialVisibilityGutter: 0
  }
};
</file>
<file name="./client/app/components/Common/ResetPasswordForm/index.js" format="js">
/**
 *
 * ResetPasswordForm
 *
 */

import React from 'react';

import { Row, Col } from 'reactstrap';

import Input from '../Input';
import Button from '../Button';

const ResetPasswordForm = props => {
  const {
    resetFormData,
    formErrors,
    isToken,
    resetPasswordChange,
    resetPassword
  } = props;

  const handleSubmit = event => {
    event.preventDefault();
    resetPassword();
  };

  return (
    <div className='reset-password-form'>
      <form onSubmit={handleSubmit} noValidate>
        <Row>
          <Col xs='12' lg='6'>
            <Input
              type={'password'}
              error={formErrors['password']}
              label={'Password'}
              name={'password'}
              placeholder={isToken ? 'Password' : 'Old Password'}
              value={resetFormData.password}
              onInputChange={(name, value) => {
                resetPasswordChange(name, value);
              }}
            />
          </Col>
          <Col xs='12' lg='6'>
            <Input
              type={'password'}
              error={formErrors['confirmPassword']}
              label={'Confirm Password'}
              name={'confirmPassword'}
              placeholder={'Confirm Password'}
              value={resetFormData.confirmPassword}
              onInputChange={(name, value) => {
                resetPasswordChange(name, value);
              }}
            />
          </Col>
        </Row>
        <hr />
        <div className='reset-actions'>
          <Button type='submit' text='Reset Password' />
        </div>
      </form>
    </div>
  );
};

export default ResetPasswordForm;
</file>
<file name="./client/app/components/Store/ProductList/index.js" format="js">
/**
 *
 * ProductList
 *
 */

import React from 'react';

import { Link } from 'react-router-dom';

import AddToWishList from '../AddToWishList';

const ProductList = props => {
  const { products, updateWishlist, authenticated } = props;

  return (
    <div className='product-list'>
      {products.map((product, index) => (
        <div key={index} className='mb-3 mb-md-0'>
          <div className='product-container'>
            <div className='item-box'>
              <div className='add-wishlist-box'>
                <AddToWishList
                  id={product._id}
                  liked={product?.isLiked ?? false}
                  enabled={authenticated}
                  updateWishlist={updateWishlist}
                  authenticated={authenticated}
                />
              </div>

              <div className='item-link'>
                <Link
                  to={`/product/${product.slug}`}
                  className='d-flex flex-column h-100'
                >
                  <div className='item-image-container'>
                    <div className='item-image-box'>
                      <img
                        className='item-image'
                        src={`${
                          product.imageUrl
                            ? product.imageUrl
                            : '/images/placeholder-image.png'
                        }`}
                      />
                    </div>
                  </div>
                  <div className='item-body'>
                    <div className='item-details p-3'>
                      <h1 className='item-name'>{product.name}</h1>
                      {product.brand && Object.keys(product.brand).length > 0 && (
                        <p className='by'>
                          By <span>{product.brand.name}</span>
                        </p>
                      )}
                      <p className='item-desc mb-0'>{product.description}</p>
                    </div>
                  </div>
                  <div className='d-flex flex-row justify-content-between align-items-center px-4 mb-2 item-footer'>
                    <p className='price mb-0'>${product.price}</p>
                    {product.totalReviews > 0 && (
                      <p className='mb-0'>
                        <span className='fs-16 fw-normal mr-1'>
                          {parseFloat(product?.averageRating).toFixed(1)}
                        </span>
                        <span
                          className={`fa fa-star ${
                            product.totalReviews !== 0 ? 'checked' : ''
                          }`}
                          style={{ color: '#ffb302' }}
                        ></span>
                      </p>
                    )}
                  </div>
                </Link>
              </div>
            </div>
          </div>
        </div>
      ))}
    </div>
  );
};

export default ProductList;
</file>
<file name="./client/app/components/Store/CartList/index.js" format="js">
/**
 *
 * CartList
 *
 */

import React from 'react';

import { Link } from 'react-router-dom';
import { Container, Row, Col } from 'reactstrap';

import Button from '../../Common/Button';

const CartList = props => {
  const { cartItems, handleRemoveFromCart } = props;

  const handleProductClick = () => {
    props.toggleCart();
  };

  return (
    <div className='cart-list'>
      {cartItems.map((item, index) => (
        <div key={index} className='item-box'>
          <div className='item-details'>
            <Container>
              <Row className='mb-2 align-items-center'>
                <Col xs='10' className='pr-0'>
                  <div className='d-flex align-items-center'>
                    <img
                      className='item-image mr-2'
                      src={`${
                        item.imageUrl
                          ? item.imageUrl
                          : '/images/placeholder-image.png'
                      }`}
                    />

                    <Link
                      to={`/product/${item.slug}`}
                      className='item-link one-line-ellipsis'
                      onClick={handleProductClick}
                    >
                      <h2 className='item-name one-line-ellipsis'>
                        {item.name}
                      </h2>
                    </Link>
                  </div>
                </Col>
                <Col xs='2' className='text-right'>
                  <Button
                    borderless
                    variant='empty'
                    ariaLabel={`remove ${item.name} from cart`}
                    icon={<i className='icon-trash' aria-hidden='true' />}
                    onClick={() => handleRemoveFromCart(item)}
                  />
                </Col>
              </Row>
              <Row className='mb-2 align-items-center'>
                <Col xs='9'>
                  <p className='item-label'>price</p>
                </Col>
                <Col xs='3' className='text-right'>
                  <p className='value price'>{` $${item?.totalPrice}`}</p>
                </Col>
              </Row>
              <Row className='mb-2 align-items-center'>
                <Col xs='9'>
                  <p className='item-label'>quantity</p>
                </Col>
                <Col xs='3' className='text-right'>
                  <p className='value quantity'>{` ${item.quantity}`}</p>
                </Col>
              </Row>
            </Container>
          </div>
        </div>
      ))}
    </div>
  );
};

export default CartList;
</file>
<file name="./client/app/components/Store/BrandList/index.js" format="js">
/**
 *
 * BrandList
 *
 */

import React from 'react';

import { Row, Col } from 'reactstrap';
import { Link } from 'react-router-dom';

const BrandList = props => {
  const { brands } = props;

  return (
    <div className='brand-list'>
      <h3 className='text-uppercase'>Shop By Brand</h3>
      <hr />
      <Row className='flex-sm-row'>
        {brands.map((brand, index) => (
          <Col xs='6' md='4' lg='3' key={index} className='mb-3 px-2'>
            <Link
              to={`/shop/brand/${brand.slug}`}
              className='d-block brand-box'
            >
              <h5>{brand.name}</h5>
              <p className='brand-desc'>{brand.description}</p>
            </Link>
          </Col>
        ))}
      </Row>
    </div>
  );
};

export default BrandList;
</file>
<file name="./client/app/components/Store/AddToWishList/index.js" format="js">
/**
 *
 * AddToWishList
 *
 */

import React from 'react';

import Checkbox from '../../Common/Checkbox';
import { HeartIcon } from '../../Common/Icon';

const AddToWishList = props => {
  const { id, liked, enabled, updateWishlist } = props;

  return (
    <div className='add-to-wishlist'>
      <Checkbox
        id={`checkbox_${id}`}
        name={'wishlist'}
        disabled={!enabled}
        checked={liked}
        label={<HeartIcon />}
        onChange={(_, value) => {
          updateWishlist(value, id);
        }}
      />
    </div>
  );
};

export default AddToWishList;
</file>
<file name="./client/app/components/Store/Checkout/index.js" format="js">
/**
 *
 * Checkout
 *
 */

import React from 'react';

import Button from '../../Common/Button';

const Checkout = props => {
  const { authenticated, handleShopping, handleCheckout, placeOrder } = props;

  return (
    <div className='easy-checkout'>
      <div className='checkout-actions'>
        <Button
          variant='primary'
          text='Continue shopping'
          onClick={() => handleShopping()}
        />
        {authenticated ? (
          <Button
            variant='primary'
            text='Place Order'
            onClick={() => placeOrder()}
          />
        ) : (
          <Button
            variant='primary'
            text='Proceed To Checkout'
            onClick={() => handleCheckout()}
          />
        )}
      </div>
    </div>
  );
};

export default Checkout;
</file>
<file name="./client/app/components/Store/CartSummary/index.js" format="js">
/**
 *
 * CartSummary
 *
 */

import React from 'react';

import { Container, Row, Col } from 'reactstrap';

const CartSummary = props => {
  const { cartTotal } = props;

  return (
    <div className='cart-summary'>
      <Container>
        <Row className='mb-2 summary-item'>
          <Col xs='9'>
            <p className='summary-label'>Free Shippling</p>
          </Col>
          <Col xs='3' className='text-right'>
            <p className='summary-value'>$0</p>
          </Col>
        </Row>
        <Row className='mb-2 summary-item'>
          <Col xs='9'>
            <p className='summary-label'>Total</p>
          </Col>
          <Col xs='3' className='text-right'>
            <p className='summary-value'>${cartTotal}</p>
          </Col>
        </Row>
      </Container>
    </div>
  );
};

export default CartSummary;
</file>
<file name="./client/app/components/Store/ProductFilter/index.js" format="js">
/**
 *
 * ProductFilter
 *
 */

import React from 'react';
import { Card, CardBody, CardHeader } from 'reactstrap';

import RangeSlider from '../../Common/RangeSlider';

const priceMarks = {
  1: { label: <p className='fw-normal text-black'>$1</p> },
  5000: { label: <p className='fw-normal text-black'>$5000</p> }
};

const rateMarks = {
  0: {
    label: (
      <span>
        <span className='mr-1'>5</span>
        <i
          className='fa fa-star fa-1x'
          style={{ display: 'contents' }}
          aria-hidden='true'
        ></i>
      </span>
    )
  },
  20: {
    label: (
      <span>
        <span className='mr-1'>4</span>
        <i className='fa fa-star fa-1x' aria-hidden='true'></i>
      </span>
    )
  },
  40: {
    label: (
      <span>
        <span className='mr-1'>3</span>
        <i className='fa fa-star fa-1x' aria-hidden='true'></i>
      </span>
    )
  },
  60: {
    label: (
      <span>
        <span className='mr-1'>2</span>
        <i className='fa fa-star fa-1x' aria-hidden='true'></i>
      </span>
    )
  },
  80: {
    label: (
      <span>
        <span className='mr-1'>1</span>
        <i className='fa fa-star fa-1x' aria-hidden='true'></i>
      </span>
    )
  },
  100: { label: <span>Any</span> }
};

const rating = v => {
  switch (v) {
    case 100:
      return 0;
    case 80:
      return 1;
    case 60:
      return 2;
    case 40:
      return 3;
    case 20:
      return 4;
    default:
      0;
      return 5;
  }
};

const ProductFilter = props => {
  const { filterProducts } = props;

  return (
    <div className='product-filter'>
      <Card className='mb-4'>
        <CardHeader tag='h3'>Price</CardHeader>
        <CardBody>
          <div className='mx-2 mb-3'>
            <RangeSlider
              marks={priceMarks}
              defaultValue={[1, 2500]}
              max={5000}
              onChange={v => {
                filterProducts('price', v);
              }}
            />
          </div>
        </CardBody>
      </Card>
      <Card>
        <CardHeader tag='h3'>Rating</CardHeader>
        <CardBody>
          <div className='mx-2 mb-4'>
            <RangeSlider
              type='slider'
              marks={rateMarks}
              step={20}
              defaultValue={[100]}
              onChange={v => {
                filterProducts('rating', rating(v));
              }}
            />
          </div>
        </CardBody>
      </Card>
    </div>
  );
};

export default ProductFilter;
</file>
<file name="./client/app/components/Store/ProductReviews/index.js" format="js">
/**
 *
 * ProductReviews
 *
 */

import React from 'react';
import { Row, Col } from 'reactstrap';

import AddReview from './Add';
import ReviewList from './List';
import ReviewSummary from './Summary';

const ProductReviews = props => {
  return (
    <div className='mt-md-4 product-reviews'>
      <Row className='flex-row'>
        <Col xs='12' md='5' lg='5' className='mb-3 px-3 px-md-2'>
          {Object.keys(props.reviewsSummary).length > 0 && (
            <ReviewSummary reviewsSummary={props.reviewsSummary} />
          )}
        </Col>
        <Col xs='12' md='7' lg='7' className='mb-3 px-3 px-md-2'>
          {props.reviews.length > 0 && <ReviewList reviews={props.reviews} />}
          <AddReview
            reviewFormData={props.reviewFormData}
            reviewChange={props.reviewChange}
            reviewFormErrors={props.reviewFormErrors}
            addReview={props.addReview}
          />
        </Col>
      </Row>
    </div>
  );
};

export default ProductReviews;
</file>
<file name="./client/app/components/Store/ProductReviews/Add.js" format="js">
/**
 *
 * Add
 *
 */

import React from 'react';

import { Row, Col } from 'reactstrap';

import SelectOption from '../../Common/SelectOption';
import Input from '../../Common/Input';
import Button from '../../Common/Button';

const recommedableSelect = [
  { value: 1, label: 'Yes' },
  { value: 0, label: 'No' }
];

const Add = props => {
  const { reviewFormData, reviewChange, reviewFormErrors, addReview } = props;

  const handleSubmit = event => {
    event.preventDefault();
    addReview();
  };

  return (
    <div className='bg-white p-4 box-shadow-primary add-review'>
      <form onSubmit={handleSubmit} noValidate>
        <h3 className='mb-3'>Add Review</h3>
        <Row>
          <Col xs='12' md='12'>
            <Input
              type={'text'}
              error={reviewFormErrors['title']}
              label={'Title'}
              name={'title'}
              placeholder={'Enter Review title'}
              value={reviewFormData.title}
              onInputChange={(name, value) => {
                reviewChange(name, value);
              }}
            />
          </Col>
          <Col xs='12' md='12'>
            <Input
              type={'textarea'}
              error={reviewFormErrors['review']}
              label={'Comment'}
              name={'review'}
              placeholder={'Write Review'}
              value={reviewFormData.review}
              onInputChange={(name, value) => {
                reviewChange(name, value);
              }}
            />
          </Col>
          <Col xs='12' md='12'>
            <Input
              type={'stars'}
              error={reviewFormErrors['rating']}
              label={'Rating'}
              name={'rating'}
              value={reviewFormData.rating}
              onInputChange={(name, value) => {
                reviewChange(name, value);
              }}
            />
          </Col>
          <Col xs='12' md='12'>
            <SelectOption
              error={reviewFormErrors['isRecommended']}
              label={'Will you recommend this product?'}
              name={'isRecommended'}
              value={reviewFormData.isRecommended}
              options={recommedableSelect}
              handleSelectChange={value => {
                reviewChange('isRecommended', value);
              }}
            />
          </Col>
        </Row>
        <div className='mt-4'>
          <Button type='submit' text='Publish Review' />
        </div>
      </form>
    </div>
  );
};

export default Add;
</file>
<file name="./client/app/components/Store/ProductReviews/Summary.js" format="js">
/**
 *
 * Summary
 *
 */

import React from 'react';

import ReactStars from 'react-rating-stars-component';

import NotFound from '../../Common/NotFound';
import { ReviewIcon } from '../../Common/Icon';

const Summary = props => {
  const {
    reviewsSummary: { ratingSummary, totalRatings, totalReviews, totalSummary }
  } = props;

  const getRatingPercentage = value => {
    return parseFloat(percentage(value, totalSummary).toFixed(2));
  };

  const averageRating =
    totalRatings > 0 && Math.round(totalRatings / totalReviews);

  return (
    <div className='bg-white p-4 box-shadow-primary review-summary'>
      <h2 className='mb-0'>Rating</h2>
      {averageRating && (
        <div className='d-flex flex-wrap align-items-center mt-2'>
          <ReactStars
            classNames='mr-2'
            size={17}
            edit={false}
            color={'#adb5bd'}
            activeColor={'#ffb302'}
            a11y={true}
            isHalf={true}
            emptyIcon={<i className='fa fa-star' />}
            halfIcon={<i className='fa fa-star-half-alt' />}
            filledIcon={<i className='fa fa-star' />}
            value={averageRating}
          />
          {totalReviews > 0 && <span>based on {totalReviews} reviews.</span>}
        </div>
      )}

      <hr style={{ border: '3px solid #f1f1f1' }} />
      {totalReviews > 0 ? (
        ratingSummary.map((r, obj) => (
          <div key={obj} className='d-flex align-items-center mb-2'>
            <div className='left'>
              <span>{parseInt(Object.keys(r)[0])} star</span>
            </div>
            <div className='middle'>
              <div className='bar-container'>
                <div
                  className={`bar-${parseInt(Object.keys(r)[0])}`}
                  style={{
                    width: `${getRatingPercentage(
                      parseInt(r[Object.keys(r)[0]])
                    )}%`
                  }}
                ></div>
              </div>
            </div>
            <div className='ml-2 right'>
              <span className='fw-medium'>
                {getRatingPercentage(parseInt(r[Object.keys(r)[0]]))}%
              </span>
            </div>
          </div>
        ))
      ) : (
        <NotFound>
          <ReviewIcon width='40' height='40' className='my-2' />
          <p className='mb-2'>Be the first to add a review.</p>
        </NotFound>
      )}
    </div>
  );
};

export default Summary;

function percentage(partialValue, totalValue) {
  return (100 * partialValue) / totalValue;
}
</file>
<file name="./client/app/components/Store/ProductReviews/List.js" format="js">
/**
 *
 * List
 *
 */

import React from 'react';

import ReactStars from 'react-rating-stars-component';

import { formatDate } from '../../../utils/date';
import { getRandomColors } from '../../../utils';

const List = props => {
  const { reviews } = props;

  const getAvatar = review => {
    const color = getRandomColors();
    if (review.user.firstName) {
      return (
        <div
          className='d-flex flex-column justify-content-center align-items-center fw-normal text-white avatar'
          style={{ backgroundColor: color ? color : 'red' }}
        >
          {review.user.firstName.charAt(0)}
        </div>
      );
    }
  };

  return (
    <div className='review-list'>
      {reviews.map((review, index) => (
        <div className='d-flex align-items-center mb-3 review-box' key={index}>
          <div className='mx-3'>{getAvatar(review)}</div>
          <div className='p-3 p-lg-4 w-100'>
            <div className='d-flex align-items-center justify-content-between'>
              <h4 className='mb-0 mr-2 one-line-ellipsis'>{review.title}</h4>
              <ReactStars
                classNames='mr-2'
                size={16}
                edit={false}
                color={'#adb5bd'}
                activeColor={'#ffb302'}
                a11y={true}
                isHalf={true}
                emptyIcon={<i className='fa fa-star' />}
                halfIcon={<i className='fa fa-star-half-alt' />}
                filledIcon={<i className='fa fa-star' />}
                value={review.rating}
              />
            </div>
            <p className='mb-2 fs-12'>{formatDate(`${review?.created}`)}</p>
            <p className='mb-0 three-line-ellipsis word-break-all'>{`${review?.review}`}</p>
          </div>
        </div>
      ))}
    </div>
  );
};

export default React.memo(List);
</file>
<file name="./client/app/components/Store/MiniBrand/index.js" format="js">
/**
 *
 * MiniBrand
 *
 */

import React from 'react';

import { Link } from 'react-router-dom';

const MiniBrand = props => {
  const { brands, toggleBrand } = props;

  const handleMenuItemClick = () => {
    toggleBrand();
  };

  return (
    <div className='mini-brand-list'>
      <div className='d-flex align-items-center justify-content-between min-brand-title'>
        <h4 className='mb-0 text-uppercase'>Shop By Brand</h4>
        <Link
          to={'/brands'}
          className='redirect-link'
          role='menuitem'
          onClick={handleMenuItemClick}
        >
          See all
        </Link>
      </div>
      <div className='mini-brand-block'>
        {brands.map((brand, index) => (
          <div key={index} className='brand-item'>
            <Link
              to={`/shop/brand/${brand.slug}`}
              className='brand-link'
              role='menuitem'
              onClick={handleMenuItemClick}
            >
              {brand.name}
            </Link>
          </div>
        ))}
      </div>
    </div>
  );
};

export default MiniBrand;
</file>
<file name="./client/app/components/Store/SocialShare/index.js" format="js">
/**
 *
 * SocialShare
 *
 */

import React from 'react';

import {
  EmailShareButton,
  TwitterShareButton,
  WhatsappShareButton,
  FacebookShareButton
} from 'react-share';

const SocialShare = props => {
  const { product } = props;

  const shareMsg = `I ♥ ${
    product.name
  } product on Mern Store!  Here's the link, ${
    window.location.protocol !== 'https' ? 'http' : 'https'
  }://${window.location.host}/product/${product.slug}`;

  return (
    <ul className='d-flex flex-row mx-0 mb-0 justify-content-center justify-content-md-start share-box'>
      <li>
        <FacebookShareButton url={`${shareMsg}`} className='share-btn facebook'>
          <i className='fa fa-facebook'></i>
        </FacebookShareButton>
      </li>
      <li>
        <TwitterShareButton url={`${shareMsg}`} className='share-btn twitter'>
          <i className='fa fa-twitter'></i>
        </TwitterShareButton>
      </li>
      <li>
        <EmailShareButton url={`${shareMsg}`} className='share-btn envelope'>
          <i className='fa fa-envelope-o'></i>
        </EmailShareButton>
      </li>
      <li>
        <WhatsappShareButton url={`${shareMsg}`} className='share-btn whatsapp'>
          <i className='fa fa-whatsapp'></i>
        </WhatsappShareButton>
      </li>
    </ul>
  );
};

export default SocialShare;
</file>
<file name="./client/app/components/Manager/OrderSummary/index.js" format="js">
/**
 *
 * OrderSummary
 *
 */

import React from 'react';

import { Col } from 'reactstrap';

const OrderSummary = props => {
  const { order } = props;

  return (
    <Col className='order-summary pt-3'>
      <h2>Order Summary</h2>
      <div className='d-flex align-items-center summary-item'>
        <p className='summary-label'>Subtotal</p>
        <p className='summary-value ml-auto'>${order.total}</p>
      </div>
      <div className='d-flex align-items-center summary-item'>
        <p className='summary-label'>Est. Sales Tax</p>
        <p className='summary-value ml-auto'>${order.totalTax}</p>
      </div>

      <div className='d-flex align-items-center summary-item'>
        <p className='summary-label'>Shipping & Handling</p>
        <p className='summary-value ml-auto'>$0</p>
      </div>

      <hr />
      <div className='d-flex align-items-center summary-item'>
        <p className='summary-label'>Total</p>
        <p className='summary-value ml-auto'>${order.totalWithTax}</p>
      </div>
    </Col>
  );
};

export default OrderSummary;
</file>
<file name="./client/app/components/Manager/ProductList/index.js" format="js">
/**
 *
 * ProductList
 *
 */

import React from 'react';

import { Link } from 'react-router-dom';

const ProductList = props => {
  const { products } = props;

  return (
    <div className='p-list'>
      {products.map((product, index) => (
        <Link
          to={`/dashboard/product/edit/${product._id}`}
          key={index}
          className='d-flex flex-row align-items-center mx-0 mb-3 product-box'
        >
          <img
            className='item-image'
            src={`${
              product && product.imageUrl
                ? product.imageUrl
                : '/images/placeholder-image.png'
            }`}
          />
          <div className='d-flex flex-column justify-content-center px-3 text-truncate'>
            <h4 className='text-truncate'>{product.name}</h4>
            <p className='mb-2 text-truncate'>{product.description}</p>
          </div>
        </Link>
      ))}
    </div>
  );
};

export default ProductList;
</file>
<file name="./client/app/components/Manager/SubPage/index.js" format="js">
/**
 *
 * SubPage
 *
 */

import React from 'react';

import Button from '../../Common/Button';

const SubPage = props => {
  const { title, actionTitle, handleAction, children } = props;

  return (
    <div className='sub-page'>
      <div className='subpage-header'>
        <h3 className='mb-0'>{title}</h3>
        {actionTitle && (
          <div className='action'>
            <Button
              variant='none'
              size='sm'
              text={actionTitle}
              onClick={handleAction}
            />
          </div>
        )}
      </div>
      <div className='subpage-body'>{children}</div>
    </div>
  );
};

export default SubPage;
</file>
<file name="./client/app/components/Manager/AccountDetails/index.js" format="js">
/**
 *
 * AccountDetails
 *
 */

import React from 'react';

import { Row, Col } from 'reactstrap';

import { EMAIL_PROVIDER } from '../../../constants';
import UserRole from '../UserRole';
import Input from '../../Common/Input';
import Button from '../../Common/Button';

const AccountDetails = props => {
  const { user, accountChange, updateProfile } = props;

  const handleSubmit = event => {
    event.preventDefault();
    updateProfile();
  };

  return (
    <div className='account-details'>
      <div className='info'>
        <div className='desc'>
          <p className='one-line-ellipsis mr-3'>
            {user.provider === EMAIL_PROVIDER.Email ? (
              user.email
            ) : (
              <span className='provider-email'>
                Logged in With {user.provider}
              </span>
            )}
          </p>
          <UserRole user={user} />
        </div>
      </div>
      <form onSubmit={handleSubmit}>
        <Row>
          <Col xs='12' md='6'>
            <Input
              type={'text'}
              label={'First Name'}
              name={'firstName'}
              placeholder={'Please Enter Your First Name'}
              value={user.firstName ? user.firstName : ''}
              onInputChange={(name, value) => {
                accountChange(name, value);
              }}
            />
          </Col>
          <Col xs='12' md='6'>
            <Input
              type={'text'}
              label={'Last Name'}
              name={'lastName'}
              placeholder={'Please Enter Your Last Name'}
              value={user.lastName ? user.lastName : ''}
              onInputChange={(name, value) => {
                accountChange(name, value);
              }}
            />
          </Col>
          {/* TODO: update email feature to be added instead form change */}
          {/* <Col xs='12' md='6'>
            <Input
              type={'text'}
              label={'Email'}
              name={'email'}
              placeholder={'Please Enter Your Email'}
              value={user.email ? user.email : ''}
              onInputChange={(name, value) => {
                accountChange(name, value);
              }}
            />
          </Col> */}
          <Col xs='12' md='12'>
            <Input
              type={'text'}
              label={'Phone Number'}
              name={'phoneNumber'}
              placeholder={'Please Enter Your Phone Number'}
              value={user.phoneNumber ? user.phoneNumber : ''}
              onInputChange={(name, value) => {
                accountChange(name, value);
              }}
            />
          </Col>
        </Row>
        <hr />
        <div className='profile-actions'>
          <Button type='submit' variant='secondary' text='Save changes' />
        </div>
      </form>
    </div>
  );
};

export default AccountDetails;
</file>
<file name="./client/app/components/Manager/OrderMeta/index.js" format="js">
/**
 *
 * OrderMeta
 *
 */

import React from 'react';

import { Row, Col } from 'reactstrap';

import { CART_ITEM_STATUS } from '../../../constants';
import { formatDate } from '../../../utils/date';
import Button from '../../Common/Button';
import { ArrowBackIcon } from '../../Common/Icon';

const OrderMeta = props => {
  const { order, cancelOrder, onBack } = props;

  const renderMetaAction = () => {
    const isNotDelivered =
      order.products.filter(i => i.status === CART_ITEM_STATUS.Delivered)
        .length < 1;

    if (isNotDelivered) {
      return <Button size='sm' text='Cancel Order' onClick={cancelOrder} />;
    }
  };

  return (
    <div className='order-meta'>
      <div className='d-flex align-items-center justify-content-between mb-3 title'>
        <h2 className='mb-0'>Order Details</h2>
        <Button
          variant='link'
          icon={<ArrowBackIcon />}
          size='sm'
          text='Back to orders'
          onClick={onBack}
        ></Button>
      </div>

      <Row>
        <Col xs='12' md='8'>
          <Row>
            <Col xs='4'>
              <p className='one-line-ellipsis'>Order ID</p>
            </Col>
            <Col xs='8'>
              <span className='order-label one-line-ellipsis'>{` ${order._id}`}</span>
            </Col>
          </Row>
          <Row>
            <Col xs='4'>
              <p className='one-line-ellipsis'>Order Date</p>
            </Col>
            <Col xs='8'>
              <span className='order-label one-line-ellipsis'>{` ${formatDate(
                order.created
              )}`}</span>
            </Col>
          </Row>
        </Col>
        <Col xs='12' md='4' className='text-left text-md-right'>
          {renderMetaAction()}
        </Col>
      </Row>
    </div>
  );
};

export default OrderMeta;
</file>
<file name="./client/app/components/Manager/BrandList/index.js" format="js">
/**
 *
 * BrandList
 *
 */

import React from 'react';

import { Link } from 'react-router-dom';

const BrandList = props => {
  const { brands, user } = props;

  return (
    <div className='b-list'>
      {brands.map((brand, index) => (
        <Link
          to={`/dashboard/brand/edit/${brand._id}`}
          key={index}
          className='d-block mb-3 p-4 brand-box'
        >
          <div className='d-flex align-items-center justify-content-between mb-2'>
            <h4 className='mb-0'>{brand.name}</h4>
          </div>
          <p className='brand-desc mb-2'>{brand.description}</p>
          {brand?.merchant && brand?.merchant?._id !== user?.merchant && (
            <div className='d-flex'>
              <label>By</label>
              <p className='brand-merchant mb-0 ml-2 text-primary'>
                {brand.merchant.name}
              </p>
            </div>
          )}
        </Link>
      ))}
    </div>
  );
};

export default BrandList;
</file>
<file name="./client/app/components/Manager/OrderDetails/index.js" format="js">
/**
 *
 * OrderDetails
 *
 */

import React from 'react';

import { Row, Col } from 'reactstrap';

import OrderMeta from '../OrderMeta';
import OrderItems from '../OrderItems';
import OrderSummary from '../OrderSummary';

const OrderDetails = props => {
  const { order, user, cancelOrder, updateOrderItemStatus, onBack } = props;
  return (
    <div className='order-details'>
      <Row>
        <Col xs='12' md='12'>
          <OrderMeta order={order} cancelOrder={cancelOrder} onBack={onBack} />
        </Col>
      </Row>
      <Row className='mt-5'>
        <Col xs='12' lg='8'>
          <OrderItems
            order={order}
            user={user}
            updateOrderItemStatus={updateOrderItemStatus}
          />
        </Col>
        <Col xs='12' lg='4' className='mt-5 mt-lg-0'>
          <OrderSummary order={order} />
        </Col>
      </Row>
    </div>
  );
};

export default OrderDetails;
</file>
<file name="./client/app/components/Manager/Support/MessageList.js" format="js">
import React, { useEffect, useRef, memo } from 'react';

import { getMemoizedRandomColors } from '../../../utils';
import { formatTime } from '../../../utils/date';
import NotFound from '../../Common/NotFound';

const MessagesList = props => {
  const { user, messages } = props;
  const messagesEndRef = useRef(null);
  const msgsLength = messages.length;
  const emptyMsgs = msgsLength > 0 ? false : true;

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({
      behavior: 'smooth'
    });
  };

  useEffect(() => {
    scrollToBottom();
  }, [msgsLength]);

  const renderMessages = () =>
    messages.map(message => (
      <Message
        key={message.id}
        message={message}
        isMe={message.from === user._id}
        noHeader={message.noHeader}
      />
    ));

  return (
    <>
      {messages && !emptyMsgs ? (
        <div className={`m-list ${!emptyMsgs ? '' : 'empty'}`}>
          {renderMessages()}
          <div ref={messagesEndRef} />
        </div>
      ) : (
        <div className='my-4'>
          <NotFound message='No messages found.' />
        </div>
      )}
    </>
  );
};

const Message = memo(props => {
  const { message, isMe, noHeader } = props;

  const getAvatar = m => {
    const color = getMemoizedRandomColors(m.from);

    if (m.user.name) {
      return (
        <div
          className='d-flex flex-column justify-content-center align-items-center fw-normal text-white avatar '
          style={{ backgroundColor: color ? color : 'red' }}
        >
          {m.user.name.charAt(0)}
        </div>
      );
    }
  };

  return (
    <div className='m-container'>
      <div
        className={`d-flex ${
          isMe ? 'justify-content-end' : 'justify-content-start'
        }`}
      >
        {!isMe && (
          <div className='mr-2 avatar-box'>
            {!noHeader && <> {getAvatar(message)}</>}
          </div>
        )}

        <div>
          {isMe ? (
            <div className='mb-2 text-right text-black'>
              {formatTime(message.time)}
            </div>
          ) : (
            <div className={`d-flex mb-2 text-right`}>
              {!noHeader && (
                <>
                  <p className={`mb-0 fw-normal text-black`}>
                    {message.user.name}
                  </p>
                  <div className='ml-2 text-black'>
                    {formatTime(message.time)}
                  </div>
                </>
              )}
            </div>
          )}

          <p className={`${isMe ? 'me' : ''} m-box`}>{message.value}</p>
        </div>
      </div>
    </div>
  );
});

export default MessagesList;
</file>
<file name="./client/app/components/Manager/Support/UserList.js" format="js">
import React from 'react';
import Button from '../../Common/Button';

const UserList = props => {
  const { users, selectedUser, selectUser } = props;
  if (!users) return null;

  const _selectUser = u => {
    selectUser(u);
  };

  return (
    <ul className='u-list'>
      {users.map((u, i) => {
        const isSelected = selectedUser?.id === u.id;
        const isOnline = u.online ? true : false;

        return (
          <li className={isSelected ? 'selected' : 'not-selected'} key={i}>
            <Button
              variant='none'
              borderless
              text={u.name}
              onClick={() => _selectUser(u)}
              // disabled={!isOnline}
              iconDirection='right'
              icon={
                <span
                  className={`circle ${isOnline ? 'online' : 'offline'}`}
                ></span>
              }
            />
          </li>
        );
      })}
    </ul>
  );

  // return (
  //   <>
  //     {users.filter(x => x._id !== user._id).length === 0 && (
  //       <MessageBox>No Online User Found</MessageBox>
  //     )}
  //     <ul>
  //       {users
  //         .filter(x => x._id !== user._id)
  //         .map((user, index) => (
  //           <li
  //             style={{ animationDelay: `0.2s` }}
  //             key={index}
  //             className={
  //               user._id === selectedUser?._id
  //                 ? `chatlist-item active `
  //                 : 'chatlist-item'
  //             }
  //           >
  //             <button
  //               className='block'
  //               type='button'
  //               onClick={() => selectUser(user)}
  //             >
  //               {user.name}
  //             </button>
  //             <div>
  //               <span
  //                 className={
  //                   user.unread ? 'unread' : user.online ? 'online' : 'offline'
  //                 }
  //               />
  //             </div>
  //           </li>
  //         ))}
  //     </ul>
  //   </>
  // );
};

export default UserList;
</file>
<file name="./client/app/components/Manager/Support/index.js" format="js">
import React, { useEffect, useState } from 'react';
import { Row, Col } from 'reactstrap';

import { useSocket } from '../../../contexts/Socket';
import AddMessage from './AddMessage';
import MessageList from './MessageList';
import UserList from './UserList';
import NotFound from '../../Common/NotFound';

const Support = props => {
  const { user: me } = props;
  const [messages, setMessages] = useState([]);
  const [users, setUsers] = useState([]);
  const [selectedUser, setSelectedUser] = useState(null);
  const [activeChat, setActiveChat] = useState([]);
  const { socket, connect, disconnect } = useSocket();

  useEffect(() => {
    connect();
  }, []);

  useEffect(() => {
    if (socket) {
      socket.emit('connectUser');
      socket.emit('getUsers');
      socket.emit('getMessages');
      socket.on('getUsers', users => {
        setUsers(users);
      });
      socket.on('getMessages', msgs => {
        setMessages(prevState => [...prevState, ...msgs]);
      });
      socket.on('message', onMessage);
    }

    return () => {
      disconnect();
    };
  }, [socket]);

  /* user connect/disconnect implementation */
  useEffect(() => {
    if (socket && users) {
      socket.on('connectUser', user => {
        const index = users.findIndex(u => u.id === user.id);
        let newUsers = [...users];
        if (index !== -1) {
          newUsers[index] = user;
        } else {
          newUsers = [...newUsers, user];
        }
        setUsers(newUsers);
      });

      socket.on('disconnectUser', user => {
        const index = users.findIndex(u => u.id === user.id);
        const newUsers = [...users];
        if (index !== -1) {
          newUsers[index] = user;
        }
        setUsers(newUsers);
      });
    }
  }, [socket, users]);

  useEffect(() => {
    if (messages.length > 0) {
      if (selectedUser) {
        selectUser(selectedUser);
      } else {
        const user_id = localStorage.getItem('selected_suport_chat');
        if (user_id) {
          const user = users.find(u => u.id === user_id);
          if (user) selectUser(user);
        }
      }
    }
  }, [messages]);

  const onMessage = message => {
    setMessages(prevState => [...prevState, message]);
  };

  const selectUser = user => {
    setSelectedUser(user);
    const msgs = getUserMsgs(user);
    setActiveChat(msgs);
    localStorage.setItem('selected_suport_chat', user.id);
  };

  const getUserMsgs = user => {
    const sentMsgs = messages.filter(m => m.from === user.id);
    const receivedMsgs = messages.filter(m => m.to === user.id);
    const msgs = [...sentMsgs, ...receivedMsgs].sort((a, b) => a.time - b.time);
    const updatedMsgs = [];
    for (let i = 0; i < msgs.length; i++) {
      const previousMsg = msgs[i - 1];
      const currentMsg = msgs[i];
      if (previousMsg && previousMsg.from === currentMsg.from && i !== 0) {
        currentMsg.noHeader = true;
      } else {
        currentMsg.noHeader = false;
      }
      updatedMsgs.push(currentMsg);
    }
    return updatedMsgs;
  };

  const onMessageSubmit = message => {
    if (!selectedUser) return;
    socket.emit('message', {
      text: message,
      to: selectedUser?.id
    });
  };

  return (
    <>
      {socket ? (
        <>
          {users.length > 0 ? (
            <Row>
              <Col xs='12' md='4' xl='3'>
                <UserList
                  users={users}
                  selectedUser={selectedUser}
                  selectUser={selectUser}
                />
              </Col>
              <Col xs='12' md='8' xl='9'>
                {selectedUser ? (
                  <div>
                    <h4 className='text-center text-md-left mt-3 mt-md-0'>
                      {selectedUser?.name}
                    </h4>
                    <MessageList user={me} messages={activeChat} />
                    <AddMessage socket={socket} onSubmit={onMessageSubmit} />
                  </div>
                ) : (
                  <div className='d-flex flex-column justify-content-center h-100 p-4 p-md-0'>
                    <NotFound message='Select chat to start messaging' />
                  </div>
                )}
              </Col>
            </Row>
          ) : (
            <NotFound message='No users connected.' />
          )}
        </>
      ) : (
        <NotFound message='Not connected.' />
      )}
    </>
  );
};

export default Support;
</file>
<file name="./client/app/components/Manager/Support/AddMessage.js" format="js">
import React, { useState } from 'react';

import Input from '../../Common/Input';
import Button from '../../Common/Button';

const AddMessage = props => {
  const { onSubmit } = props;
  const [message, setMessage] = useState('');

  const handleOnSubmit = e => {
    e.preventDefault();
    if (!message.trim()) {
      return alert('Please type message.');
    }
    onSubmit(message);
    setMessage('');
  };

  return (
    <form onSubmit={handleOnSubmit}>
      <Input
        autoComplete='off'
        type={'text'}
        name={'message'}
        placeholder='type message'
        value={message}
        onInputChange={(_, value) => setMessage(value)}
        inlineElement={<SendButton disabled={!message} />}
      />
    </form>
  );
};

const SendButton = ({ disabled }) => (
  <Button type='submit' disabled={disabled} variant='primary' text='Send' />
);

export default AddMessage;
</file>
<file name="./client/app/components/Manager/UserRole/index.js" format="js">
/**
 *
 * UserRole
 *
 */

import React from 'react';

import { ROLES } from '../../../constants';
import Badge from '../../Common/Badge';

const UserRole = props => {
  const { className, user } = props;

  return (
    <>
      {user.role === ROLES.Admin ? (
        <Badge variant='primary' className={className}>
          Admin
        </Badge>
      ) : user.role === ROLES.Merchant ? (
        <Badge variant='dark' className={className}>
          Merchant
        </Badge>
      ) : (
        <Badge className={className}>Member</Badge>
      )}
    </>
  );
};

UserRole.defaultProps = {
  className: ''
};

export default UserRole;
</file>
<file name="./client/app/components/Manager/SearchResultMeta/index.js" format="js">
/**
 *
 * SearchResultMeta
 *
 */

import React from 'react';

const SearchResultMeta = props => {
  const { count, label } = props;

  return (
    <p className='fw-normal'>
      {count} {label}
    </p>
  );
};

export default SearchResultMeta;
</file>
<file name="./client/app/components/Manager/Dashboard/Admin.js" format="js">
/*
 *
 * Admin
 *
 */

import React from 'react';

import { Switch, Route } from 'react-router-dom';
import { Row, Col } from 'reactstrap';

import AccountMenu from '../AccountMenu';
import Page404 from '../../Common/Page404';

import Account from '../../../containers/Account';
import AccountSecurity from '../../../containers/AccountSecurity';
import Address from '../../../containers/Address';
import Order from '../../../containers/Order';
import Users from '../../../containers/Users';
import Category from '../../../containers/Category';
import Product from '../../../containers/Product';
import Brand from '../../../containers/Brand';
import Merchant from '../../../containers/Merchant';
import Review from '../../../containers/Review';
import Wishlist from '../../../containers/WishList';

const Admin = props => {
  return (
    <div className='admin'>
      <Row>
        <Col xs='12' md='5' xl='3'>
          <AccountMenu {...props} />
        </Col>
        <Col xs='12' md='7' xl='9'>
          <div className='panel-body'>
            <Switch>
              <Route exact path='/dashboard' component={Account} />
              <Route path='/dashboard/security' component={AccountSecurity} />
              <Route path='/dashboard/address' component={Address} />
              <Route path='/dashboard/product' component={Product} />
              <Route path='/dashboard/category' component={Category} />
              <Route path='/dashboard/brand' component={Brand} />
              <Route path='/dashboard/users' component={Users} />
              <Route path='/dashboard/merchant' component={Merchant} />
              <Route path='/dashboard/orders' component={Order} />
              <Route path='/dashboard/review' component={Review} />
              <Route path='/dashboard/wishlist' component={Wishlist} />
              <Route path='*' component={Page404} />
            </Switch>
          </div>
        </Col>
      </Row>
    </div>
  );
};

export default Admin;
</file>
<file name="./client/app/components/Manager/Dashboard/Customer.js" format="js">
/*
 *
 * Customer
 *
 */

import React from 'react';

import { Switch, Route } from 'react-router-dom';
import { Row, Col } from 'reactstrap';

import AccountMenu from '../AccountMenu';
import Page404 from '../../Common/Page404';

import { isProviderAllowed } from '../../../utils/app';
import Account from '../../../containers/Account';
import AccountSecurity from '../../../containers/AccountSecurity';
import Address from '../../../containers/Address';
import Order from '../../../containers/Order';
import Wishlist from '../../../containers/WishList';

const Customer = props => {
  const { user } = props;

  return (
    <div className='customer'>
      <Row>
        <Col xs='12' md='5' xl='3'>
          <AccountMenu {...props} />
        </Col>
        <Col xs='12' md='7' xl='9'>
          <div className='panel-body'>
            <Switch>
              <Route exact path='/dashboard' component={Account} />
              {!isProviderAllowed(user.provider) && (
                <Route path='/dashboard/security' component={AccountSecurity} />
              )}
              <Route path='/dashboard/address' component={Address} />
              <Route path='/dashboard/orders' component={Order} />
              <Route path='/dashboard/wishlist' component={Wishlist} />
              <Route path='*' component={Page404} />
            </Switch>
          </div>
        </Col>
      </Row>
    </div>
  );
};

export default Customer;
</file>
<file name="./client/app/components/Manager/Dashboard/Merchant.js" format="js">
/*
 *
 * Customer
 *
 */

import React from 'react';

import { Switch, Route } from 'react-router-dom';
import { Row, Col } from 'reactstrap';

import AccountMenu from '../AccountMenu';
import Page404 from '../../Common/Page404';

import Account from '../../../containers/Account';
import AccountSecurity from '../../../containers/AccountSecurity';
import Address from '../../../containers/Address';
import Product from '../../../containers/Product';
import Brand from '../../../containers/Brand';
import Order from '../../../containers/Order';
import Wishlist from '../../../containers/WishList';

const Merchant = props => {
  return (
    <div className='merchant'>
      <Row>
        <Col xs='12' md='5' xl='3'>
          <AccountMenu {...props} />
        </Col>
        <Col xs='12' md='7' xl='9'>
          <div className='panel-body'>
            <Switch>
              <Route exact path='/dashboard' component={Account} />
              <Route path='/dashboard/security' component={AccountSecurity} />
              <Route path='/dashboard/address' component={Address} />
              <Route path='/dashboard/product' component={Product} />
              <Route path='/dashboard/brand' component={Brand} />
              <Route path='/dashboard/orders' component={Order} />
              <Route path='/dashboard/wishlist' component={Wishlist} />
              <Route path='*' component={Page404} />
            </Switch>
          </div>
        </Col>
      </Row>
    </div>
  );
};

export default Merchant;
</file>
<file name="./client/app/components/Manager/DisabledAccount/Merchant.js" format="js">
/*
 *
 * DisabledMerchantAccount
 *
 */

import React from 'react';

const DisabledMerchantAccount = props => {
  const { user } = props;

  return (
    <div
      className='d-flex flex-column justify-content-center align-items-center'
      style={{ minHeight: 250 }}
    >
      <h3 className='mb-3'>Hi, {user.firstName}</h3>
      <div className='p-4 rounded-sm bg-secondary'>
        <h5>Unfortunately it seems your account has been disabled.</h5>
        <p className='text-gray mb-1'>
          Please contact admin to request access again.
        </p>
        <div className='mt-2'>
          <i className='fa fa-phone mr-2' />
          <span>Call us 951-999-9999</span>
        </div>
      </div>
    </div>
  );
};

export default DisabledMerchantAccount;
</file>
<file name="./client/app/components/Manager/OrderList/index.js" format="js">
/**
 *
 * OrderList
 *
 */

import React from 'react';

import { Link } from 'react-router-dom';

import { formatDate } from '../../../utils/date';

const OrderList = props => {
  const { orders } = props;

  const renderFirstItem = order => {
    if (order.products) {
      const product = order.products[0].product;
      return (
        <img
          className='item-image'
          src={`${
            product && product?.imageUrl
              ? product?.imageUrl
              : '/images/placeholder-image.png'
          }`}
        />
      );
    } else {
      return <img className='item-image' src='/images/placeholder-image.png' />;
    }
  };

  return (
    <div className='order-list'>
      {orders.map((order, index) => (
        <div key={index} className='order-box'>
          <Link to={`/order/${order._id}`} className='d-block box-link'>
            <div className='d-flex flex-column flex-lg-row mb-3'>
              <div className='order-first-item p-lg-3'>
                {renderFirstItem(order)}
              </div>
              <div className='d-flex flex-column flex-xl-row justify-content-between flex-1 ml-lg-2 mr-xl-4 p-3'>
                <div className='order-details'>
                  <div className='mb-1'>
                    <span>Status</span>
                    {order?.products ? (
                      <span className='order-label order-status'>{` ${order?.products[0].status}`}</span>
                    ) : (
                      <span className='order-label order-status'>{` Unavailable`}</span>
                    )}
                  </div>
                  <div className='mb-1'>
                    <span>Order #</span>
                    <span className='order-label'>{` ${order._id}`}</span>
                  </div>
                  <div className='mb-1'>
                    <span>Ordered on</span>
                    <span className='order-label'>{` ${formatDate(
                      order.created
                    )}`}</span>
                  </div>
                  <div className='mb-1'>
                    <span>Order Total</span>
                    <span className='order-label'>{` $${
                      order?.totalWithTax ? order?.totalWithTax : 0
                    }`}</span>
                  </div>
                </div>
              </div>
            </div>
          </Link>
        </div>
      ))}
    </div>
  );
};

export default OrderList;
</file>
<file name="./client/app/components/Manager/EditProduct/index.js" format="js">
/**
 *
 * EditProduct
 *
 */

import React from 'react';

import { Link } from 'react-router-dom';
import { Row, Col } from 'reactstrap';

import { ROLES } from '../../../constants';
import Input from '../../Common/Input';
import Switch from '../../Common/Switch';
import Button from '../../Common/Button';
import SelectOption from '../../Common/SelectOption';

const taxableSelect = [
  { value: 1, label: 'Yes' },
  { value: 0, label: 'No' }
];

const EditProduct = props => {
  const {
    user,
    product,
    productChange,
    formErrors,
    brands,
    updateProduct,
    deleteProduct,
    activateProduct
  } = props;

  const handleSubmit = event => {
    event.preventDefault();
    updateProduct();
  };

  return (
    <div className='edit-product'>
      <div className='d-flex flex-row mx-0 mb-3'>
        <label className='mr-1'>Product link </label>
        <Link to={`/product/${product.slug}`} className='default-link'>
          {product.slug}
        </Link>
      </div>

      <form onSubmit={handleSubmit} noValidate>
        <Row>
          <Col xs='12'>
            <Input
              type={'text'}
              error={formErrors['name']}
              label={'Name'}
              name={'name'}
              placeholder={'Product Name'}
              value={product.name}
              onInputChange={(name, value) => {
                productChange(name, value);
              }}
            />
          </Col>
          <Col xs='12'>
            <Input
              type={'text'}
              error={formErrors['sku']}
              label={'Sku'}
              name={'sku'}
              placeholder={'Product Sku'}
              value={product.sku}
              onInputChange={(name, value) => {
                productChange(name, value);
              }}
            />
          </Col>
          <Col xs='12'>
            <Input
              type={'text'}
              error={formErrors['slug']}
              label={'Slug'}
              name={'slug'}
              placeholder={'Product Slug'}
              value={product.slug}
              onInputChange={(name, value) => {
                productChange(name, value);
              }}
            />
          </Col>
          <Col xs='12' md='12'>
            <Input
              type={'textarea'}
              error={formErrors['description']}
              label={'Description'}
              name={'description'}
              placeholder={'Product Description'}
              value={product.description}
              onInputChange={(name, value) => {
                productChange(name, value);
              }}
            />
          </Col>
          <Col xs='12' lg='6'>
            <Input
              type={'number'}
              error={formErrors['quantity']}
              label={'Quantity'}
              name={'quantity'}
              decimals={false}
              placeholder={'Product Quantity'}
              value={product.quantity}
              onInputChange={(name, value) => {
                productChange(name, value);
              }}
            />
          </Col>
          <Col xs='12' lg='6'>
            <Input
              type={'number'}
              error={formErrors['price']}
              label={'Price'}
              name={'price'}
              min={1}
              placeholder={'Product Price'}
              value={product.price}
              onInputChange={(name, value) => {
                productChange(name, value);
              }}
            />
          </Col>
          <Col xs='12' md='12'>
            <SelectOption
              error={formErrors['taxable']}
              label={'Taxable'}
              multi={false}
              name={'taxable'}
              value={[product.taxable ? taxableSelect[0] : taxableSelect[1]]}
              options={taxableSelect}
              handleSelectChange={value => {
                productChange('taxable', value.value);
              }}
            />
          </Col>
          {user.role === ROLES.Admin && (
            <Col xs='12' md='12'>
              <SelectOption
                error={formErrors['brand']}
                label={'Select Brand'}
                multi={false}
                value={product.brand}
                options={brands}
                handleSelectChange={value => {
                  productChange('brand', value);
                }}
              />
            </Col>
          )}
          <Col xs='12' md='12' className='mt-3 mb-2'>
            <Switch
              id={`enable-product-${product._id}`}
              name={'isActive'}
              label={'Active?'}
              checked={product?.isActive}
              toggleCheckboxChange={value => {
                productChange('isActive', value);
                activateProduct(product._id, value);
              }}
            />
          </Col>
        </Row>
        <hr />
        <div className='d-flex flex-column flex-md-row'>
          <Button
            type='submit'
            text='Save'
            className='mb-3 mb-md-0 mr-0 mr-md-3'
          />
          <Button
            variant='danger'
            text='Delete'
            onClick={() => deleteProduct(product._id)}
          />
        </div>
      </form>
    </div>
  );
};

export default EditProduct;
</file>
<file name="./client/app/components/Manager/MerchantSearch/index.js" format="js">
/**
 *
 * MerchantSearch
 *
 */

import React from 'react';

import SearchBar from '../../Common/SearchBar';

const MerchantSearch = props => {
  return (
    <div className='mb-3'>
      <SearchBar
        name='merchant'
        placeholder='Type email, phone number, brand or status'
        btnText='Search'
        onSearch={props.onSearch}
        onBlur={props.onBlur}
        onSearchSubmit={props.onSearchSubmit}
      />
    </div>
  );
};

export default MerchantSearch;
</file>
<file name="./client/app/components/Manager/EditCategory/index.js" format="js">
/**
 *
 * EditCategory
 *
 */

import React from 'react';

import { Link } from 'react-router-dom';
import { Row, Col } from 'reactstrap';

import Input from '../../Common/Input';
import Button from '../../Common/Button';
import SelectOption from '../../Common/SelectOption';
import Switch from '../../Common/Switch';

const EditCategory = props => {
  const {
    products,
    category,
    categoryChange,
    formErrors,
    updateCategory,
    deleteCategory,
    activateCategory
  } = props;

  const handleSubmit = event => {
    event.preventDefault();
    updateCategory();
  };

  return (
    <div className='edit-category'>
      <div className='d-flex flex-row mx-0 mb-3'>
        <label className='mr-1'>Category link </label>
        <Link to={`/shop/category/${category.slug}`} className='default-link'>
          {category.slug}
        </Link>
      </div>
      <form onSubmit={handleSubmit} noValidate>
        <Row>
          <Col xs='12'>
            <Input
              type={'text'}
              error={formErrors['name']}
              label={'Name'}
              name={'name'}
              placeholder={'Category Name'}
              value={category.name}
              onInputChange={(name, value) => {
                categoryChange(name, value);
              }}
            />
          </Col>
          <Col xs='12'>
            <Input
              type={'text'}
              error={formErrors['slug']}
              label={'Slug'}
              name={'slug'}
              placeholder={'Category Slug'}
              value={category.slug}
              onInputChange={(name, value) => {
                categoryChange(name, value);
              }}
            />
          </Col>
          <Col xs='12' md='12'>
            <Input
              type={'textarea'}
              error={formErrors['description']}
              label={'Description'}
              name={'description'}
              placeholder={'Category Description'}
              value={category.description}
              onInputChange={(name, value) => {
                categoryChange(name, value);
              }}
            />
          </Col>
          <Col xs='12' md='12'>
            <SelectOption
              error={formErrors['products']}
              label={'Select Products'}
              multi={true}
              defaultValue={category.products}
              options={products}
              handleSelectChange={value => {
                categoryChange('products', value);
              }}
            />
          </Col>
          <Col xs='12' md='12' className='mt-3 mb-2'>
            <Switch
              style={{ width: 100 }}
              tooltip={category.isActive}
              tooltipContent={`Disabling ${category.name} will also disable all ${category.name} products.`}
              id={`enable-category-${category._id}`}
              name={'isActive'}
              label={'Active?'}
              checked={category.isActive}
              toggleCheckboxChange={value =>
                activateCategory(category._id, value)
              }
            />
          </Col>
        </Row>
        <hr />
        <div className='d-flex flex-column flex-md-row'>
          <Button
            type='submit'
            text='Save'
            className='mb-3 mb-md-0 mr-0 mr-md-3'
          />
          <Button
            variant='danger'
            text='Delete'
            onClick={() => deleteCategory(category._id)}
          />
        </div>
      </form>
    </div>
  );
};

export default EditCategory;
</file>
<file name="./client/app/components/Manager/AddProduct/index.js" format="js">
/**
 *
 * AddProduct
 *
 */

import React from 'react';

import { Row, Col } from 'reactstrap';

import { ROLES } from '../../../constants';
import Input from '../../Common/Input';
import Switch from '../../Common/Switch';
import Button from '../../Common/Button';
import SelectOption from '../../Common/SelectOption';

const taxableSelect = [
  { value: 1, label: 'Yes' },
  { value: 0, label: 'No' }
];

const AddProduct = props => {
  const {
    user,
    productFormData,
    formErrors,
    productChange,
    addProduct,
    brands,
    image
  } = props;

  const handleSubmit = event => {
    event.preventDefault();
    addProduct();
  };

  return (
    <div className='add-product'>
      <form onSubmit={handleSubmit} noValidate>
        <Row>
          <Col xs='12' lg='6'>
            <Input
              type={'text'}
              error={formErrors['sku']}
              label={'Sku'}
              name={'sku'}
              placeholder={'Product Sku'}
              value={productFormData.sku}
              onInputChange={(name, value) => {
                productChange(name, value);
              }}
            />
          </Col>
          <Col xs='12' lg='6'>
            <Input
              type={'text'}
              error={formErrors['name']}
              label={'Name'}
              name={'name'}
              placeholder={'Product Name'}
              value={productFormData.name}
              onInputChange={(name, value) => {
                productChange(name, value);
              }}
            />
          </Col>
          <Col xs='12' md='12'>
            <Input
              type={'textarea'}
              error={formErrors['description']}
              label={'Description'}
              name={'description'}
              placeholder={'Product Description'}
              value={productFormData.description}
              onInputChange={(name, value) => {
                productChange(name, value);
              }}
            />
          </Col>
          <Col xs='12' lg='6'>
            <Input
              type={'number'}
              error={formErrors['quantity']}
              label={'Quantity'}
              name={'quantity'}
              decimals={false}
              placeholder={'Product Quantity'}
              value={productFormData.quantity}
              onInputChange={(name, value) => {
                productChange(name, value);
              }}
            />
          </Col>
          <Col xs='12' lg='6'>
            <Input
              type={'number'}
              error={formErrors['price']}
              label={'Price'}
              name={'price'}
              min={1}
              placeholder={'Product Price'}
              value={productFormData.price}
              onInputChange={(name, value) => {
                productChange(name, value);
              }}
            />
          </Col>
          <Col xs='12' md='12'>
            <SelectOption
              error={formErrors['taxable']}
              label={'Taxable'}
              name={'taxable'}
              options={taxableSelect}
              value={productFormData.taxable}
              handleSelectChange={value => {
                productChange('taxable', value);
              }}
            />
          </Col>
          <Col xs='12' md='12'>
            <SelectOption
              disabled={user.role === ROLES.Merchant}
              error={formErrors['brand']}
              name={'brand'}
              label={'Select Brand'}
              value={
                user.role === ROLES.Merchant ? brands[1] : productFormData.brand
              }
              options={brands}
              handleSelectChange={value => {
                productChange('brand', value);
              }}
            />
          </Col>
          <Col xs='12' md='12'>
            <Input
              type={'file'}
              error={formErrors['file']}
              name={'image'}
              label={'file'}
              placeholder={'Please Upload Image'}
              value={image}
              onInputChange={(name, value) => {
                productChange(name, value);
              }}
            />
          </Col>
          <Col xs='12' md='12' className='my-2'>
            <Switch
              id={'active-product'}
              name={'isActive'}
              label={'Active?'}
              checked={productFormData.isActive}
              toggleCheckboxChange={value => productChange('isActive', value)}
            />
          </Col>
        </Row>
        <hr />
        <div className='add-product-actions'>
          <Button type='submit' text='Add Product' />
        </div>
      </form>
    </div>
  );
};

export default AddProduct;
</file>
<file name="./client/app/components/Manager/UserSearch/index.js" format="js">
/**
 *
 * UserSearch
 *
 */

import React from 'react';

import SearchBar from '../../Common/SearchBar';

const UserSearch = props => {
  return (
    <div className='mb-3'>
      <SearchBar
        name='user'
        placeholder='Type user name or email'
        btnText='Search'
        onSearch={props.onSearch}
        onBlur={props.onBlur}
        onSearchSubmit={props.onSearchSubmit}
      />
    </div>
  );
};

export default UserSearch;
</file>
<file name="./client/app/components/Manager/EditAddress/index.js" format="js">
/**
 *
 * Edit Address
 *
 */

import React from 'react';

import { Row, Col } from 'reactstrap';

import Checkbox from '../../Common/Checkbox';
import Input from '../../Common/Input';
import Button from '../../Common/Button';

const EditAddress = props => {
  const { address, addressChange, formErrors, updateAddress, deleteAddress } =
    props;

  const handleSubmit = event => {
    event.preventDefault();
    updateAddress();
  };

  return (
    <div className='edit-address'>
      <form onSubmit={handleSubmit} noValidate>
        <Row>
          <Col xs='12' md='12'>
            <Input
              type={'text'}
              error={formErrors['address']}
              label={'Address'}
              name={'address'}
              placeholder={'Address: Street, House No / Apartment No'}
              value={address.address}
              onInputChange={(name, value) => {
                addressChange(name, value);
              }}
            />
          </Col>
          <Col xs='12' md='12'>
            <Input
              type={'text'}
              error={formErrors['city']}
              label={'City'}
              name={'city'}
              placeholder={'City'}
              value={address.city}
              onInputChange={(name, value) => {
                addressChange(name, value);
              }}
            />
          </Col>
          <Col xs='12' lg='6'>
            <Input
              type={'text'}
              error={formErrors['state']}
              label={'State'}
              name={'state'}
              placeholder={'State'}
              value={address.state}
              onInputChange={(name, value) => {
                addressChange(name, value);
              }}
            />
          </Col>
          <Col xs='12' lg='6'>
            <Input
              type={'text'}
              error={formErrors['country']}
              label={'Country'}
              name={'country'}
              placeholder={'Please Enter Your Country'}
              value={address.country}
              onInputChange={(name, value) => {
                addressChange(name, value);
              }}
            />
          </Col>
          <Col xs='12' lg='6'>
            <Input
              type={'text'}
              error={formErrors['zipCode']}
              label={'Zipcode'}
              name={'zipCode'}
              placeholder={'Please Enter Your Zipcode'}
              value={address.zipCode}
              onInputChange={(name, value) => {
                addressChange(name, value);
              }}
            />
          </Col>
          <Col xs='12' md='12'>
            <Checkbox
              id={'default'}
              label={'As the Default'}
              name={'isDefault'}
              checked={address.isDefault}
              onChange={(name, value) => {
                addressChange(name, value);
              }}
            />
          </Col>
        </Row>
        <hr />
        <div className='d-flex flex-column flex-md-row'>
          <Button
            type='submit'
            text='Save'
            className='mb-3 mb-md-0 mr-0 mr-md-3'
          />
          <Button
            variant='danger'
            text='Delete'
            onClick={() => deleteAddress(address._id)}
          />
        </div>
      </form>
    </div>
  );
};

export default EditAddress;
</file>
<file name="./client/app/components/Manager/OrderSearch/index.js" format="js">
/**
 *
 * OrderSearch
 *
 */

import React from 'react';

import SearchBar from '../../Common/SearchBar';

const OrderSearch = props => {
  return (
    <div className='mb-3'>
      <SearchBar
        name='order'
        placeholder='Type the complete order ID'
        btnText='Search'
        onSearch={props.onSearch}
        onBlur={props.onBlur}
        onSearchSubmit={props.onSearchSubmit}
      />
    </div>
  );
};

export default OrderSearch;
</file>
<file name="./client/app/components/Manager/AddCategory/index.js" format="js">
/**
 *
 * AddCategory
 *
 */

import React from 'react';

import { Row, Col } from 'reactstrap';

import Input from '../../Common/Input';
import Switch from '../../Common/Switch';
import Button from '../../Common/Button';
import SelectOption from '../../Common/SelectOption';

const AddCategory = props => {
  const {
    products,
    categoryFormData,
    formErrors,
    categoryChange,
    addCategory
  } = props;

  const handleSubmit = event => {
    event.preventDefault();
    addCategory();
  };

  return (
    <div className='add-category'>
      <form onSubmit={handleSubmit} noValidate>
        <Row>
          <Col xs='12'>
            <Input
              type={'text'}
              error={formErrors['name']}
              label={'Name'}
              name={'name'}
              placeholder={'Category Name'}
              value={categoryFormData.name}
              onInputChange={(name, value) => {
                categoryChange(name, value);
              }}
            />
          </Col>
          <Col xs='12' md='12'>
            <Input
              type={'textarea'}
              error={formErrors['description']}
              label={'Description'}
              name={'description'}
              placeholder={'Category Description'}
              value={categoryFormData.description}
              onInputChange={(name, value) => {
                categoryChange(name, value);
              }}
            />
          </Col>
          <Col xs='12' md='12'>
            <SelectOption
              error={formErrors['products']}
              label={'Select Products'}
              multi={true}
              value={categoryFormData.products}
              options={products}
              handleSelectChange={value => {
                categoryChange('products', value);
              }}
            />
          </Col>
          <Col xs='12' md='12' className='my-2'>
            <Switch
              id={'active-category'}
              name={'isActive'}
              label={'Active?'}
              checked={categoryFormData.isActive}
              toggleCheckboxChange={value => categoryChange('isActive', value)}
            />
          </Col>
        </Row>
        <hr />
        <div className='add-category-actions'>
          <Button type='submit' text='Add Category' />
        </div>
      </form>
    </div>
  );
};

export default AddCategory;
</file>
<file name="./client/app/components/Manager/EditBrand/index.js" format="js">
/**
 *
 * EditBrand
 *
 */

import React from 'react';

import { Link } from 'react-router-dom';
import { Row, Col } from 'reactstrap';

import Input from '../../Common/Input';
import Button from '../../Common/Button';
import Switch from '../../Common/Switch';
import { ROLES } from '../../../constants';

const EditBrand = props => {
  const {
    user,
    brand,
    brandChange,
    formErrors,
    updateBrand,
    deleteBrand,
    activateBrand
  } = props;

  const handleSubmit = event => {
    event.preventDefault();
    updateBrand();
  };

  return (
    <div className='edit-brand'>
      <div className='d-flex flex-row mx-0 mb-3'>
        <label className='mr-1'>Brand link </label>
        <Link to={`/shop/brand/${brand.slug}`} className='default-link'>
          {brand.slug}
        </Link>
      </div>
      <form onSubmit={handleSubmit} noValidate>
        <Row>
          <Col xs='12'>
            <Input
              type={'text'}
              error={formErrors['name']}
              label={'Name'}
              name={'name'}
              placeholder={'Brand Name'}
              value={brand.name}
              onInputChange={(name, value) => {
                brandChange(name, value);
              }}
            />
          </Col>
          <Col xs='12'>
            <Input
              type={'text'}
              error={formErrors['slug']}
              label={'Slug'}
              name={'slug'}
              placeholder={'Brand Slug'}
              value={brand.slug}
              onInputChange={(name, value) => {
                brandChange(name, value);
              }}
            />
          </Col>
          <Col xs='12' md='12'>
            <Input
              type={'textarea'}
              error={formErrors['description']}
              label={'Description'}
              name={'description'}
              placeholder={'Brand Description'}
              value={brand.description}
              onInputChange={(name, value) => {
                brandChange(name, value);
              }}
            />
          </Col>
          <Col xs='12' md='12' className='mt-3 mb-2'>
            <Switch
              style={{ width: 100 }}
              tooltip={brand.isActive}
              tooltipContent={`Disabling ${brand.name} will also disable all ${brand.name} products.`}
              id={`enable-brand-${brand._id}`}
              name={'isActive'}
              label={'Active?'}
              checked={brand.isActive}
              toggleCheckboxChange={value => activateBrand(brand._id, value)}
            />
          </Col>
        </Row>
        <hr />
        <div className='d-flex flex-column flex-md-row'>
          <Button
            type='submit'
            text='Save'
            className='mb-3 mb-md-0 mr-0 mr-md-3'
          />
          <Button
            variant='danger'
            text='Delete'
            disabled={user.role === ROLES.Merchant}
            onClick={() => deleteBrand(brand._id)}
          />
        </div>
      </form>
    </div>
  );
};

export default EditBrand;
</file>
<file name="./client/app/components/Manager/AddAddress/index.js" format="js">
/**
 *
 * AddAddress
 *
 */

import React from 'react';

import { Row, Col } from 'reactstrap';

import Checkbox from '../../Common/Checkbox';
import Input from '../../Common/Input';
import Button from '../../Common/Button';

const AddAddress = props => {
  const { addressFormData, formErrors, addressChange, addAddress } = props;

  const handleSubmit = event => {
    event.preventDefault();
    addAddress();
  };

  return (
    <div className='add-address'>
      <form onSubmit={handleSubmit} noValidate>
        <Row>
          <Col xs='12' md='12'>
            <Input
              type={'text'}
              error={formErrors['address']}
              label={'Address'}
              name={'address'}
              placeholder={'Address: Street, House No / Apartment No'}
              value={addressFormData.address}
              onInputChange={(name, value) => {
                addressChange(name, value);
              }}
            />
          </Col>
          <Col xs='12' md='12'>
            <Input
              type={'text'}
              error={formErrors['city']}
              label={'City'}
              name={'city'}
              placeholder={'City'}
              value={addressFormData.city}
              onInputChange={(name, value) => {
                addressChange(name, value);
              }}
            />
          </Col>
          <Col xs='12' lg='6'>
            <Input
              type={'text'}
              error={formErrors['state']}
              label={'State'}
              name={'state'}
              placeholder={'State'}
              value={addressFormData.state}
              onInputChange={(name, value) => {
                addressChange(name, value);
              }}
            />
          </Col>
          <Col xs='12' lg='6'>
            <Input
              type={'text'}
              error={formErrors['country']}
              label={'Country'}
              name={'country'}
              placeholder={'Please Enter Your country'}
              value={addressFormData.country}
              onInputChange={(name, value) => {
                addressChange(name, value);
              }}
            />
          </Col>
          <Col xs='12' lg='6'>
            <Input
              type={'text'}
              error={formErrors['zipCode']}
              label={'Zipcode'}
              name={'zipCode'}
              placeholder={'Please Enter Your Zipcode'}
              value={addressFormData.zipCode}
              onInputChange={(name, value) => {
                addressChange(name, value);
              }}
            />
          </Col>
          <Col xs='12' md='12'>
            <Checkbox
              id={'default'}
              label={'As the Default'}
              name={'isDefault'}
              checked={addressFormData.isDefault}
              onChange={(name, value) => {
                addressChange(name, value);
              }}
            />
          </Col>
        </Row>
        <hr />
        <div className='add-address-actions'>
          <Button type='submit' text='Add Address' />
        </div>
      </form>
    </div>
  );
};

export default AddAddress;
</file>
<file name="./client/app/components/Manager/ReviewList/index.js" format="js">
/**
 *
 * ReviewList
 *
 */

import React from 'react';

import { Link } from 'react-router-dom';
import ReactStars from 'react-rating-stars-component';

import { REVIEW_STATUS } from '../../../constants';
import { formatDate } from '../../../utils/date';
import { getRandomColors } from '../../../utils';
import Button from '../../Common/Button';
import { CheckIcon, RefreshIcon, TrashIcon } from '../../Common/Icon';

const ReviewList = props => {
  const { reviews, approveReview, rejectReview, deleteReview } = props;

  const getAvatar = review => {
    const color = getRandomColors();
    if (review.user.firstName) {
      return (
        <div
          className='d-flex flex-column justify-content-center align-items-center fw-normal text-white avatar'
          style={{ backgroundColor: color ? color : 'red' }}
        >
          {review.user.firstName.charAt(0)}
        </div>
      );
    }
  };

  const getProduct = review => {
    if (review.product) {
      const product = review.product;
      return (
        <div className='d-flex flex-column justify-content-center align-items-center'>
          <img
            className='item-image'
            src={`${
              product.imageUrl
                ? product.imageUrl
                : '/images/placeholder-image.png'
            }`}
          />
        </div>
      );
    }
  };

  return (
    <div className='r-list'>
      {reviews.map((review, index) => (
        <div key={index} className='review-box'>
          <div className='mb-3 p-4'>
            <div className='d-flex flex-row mx-0 mb-2 mb-lg-3 align-items-center justify-content-between'>
              <div className='review-content'>
                <div className='d-flex flex-row mx-0 mb-2 align-items-center justify-content-between'>
                  <p className='mb-0 fw-medium fs-16 text-truncate'>
                    {review.title}
                  </p>
                  <div className='d-block d-lg-none'>{getAvatar(review)}</div>
                </div>
                <p className='mb-0 fw-normal fs-14 word-break-all'>
                  {review.review}
                </p>
              </div>
              <div className='d-none d-lg-block'>{getAvatar(review)}</div>
            </div>
            <div className='d-flex flex-column flex-lg-row mx-0 mb-3 align-items-start justify-content-between'>
              <div className='w-100 mb-3 mb-lg-0 review-product-box'>
                {review.product ? (
                  <Link
                    to={`/product/${review.product.slug}`}
                    className='default-link'
                  >
                    {review?.product.name}
                  </Link>
                ) : (
                  <p>Product is not available.</p>
                )}
                <ReactStars
                  classNames='mt-1 mt-lg-2'
                  size={16}
                  edit={false}
                  color={'#adb5bd'}
                  activeColor={'#ffb302'}
                  a11y={true}
                  isHalf={true}
                  emptyIcon={<i className='fa fa-star' />}
                  halfIcon={<i className='fa fa-star-half-alt' />}
                  filledIcon={<i className='fa fa-star' />}
                  value={review.rating}
                />
              </div>
              {getProduct(review)}
            </div>
            <label className='text-black'>{`Review Added on ${formatDate(
              review.created
            )}`}</label>
            <hr />
            {review.status === REVIEW_STATUS.Approved ? (
              <div className='d-flex flex-column flex-lg-row justify-content-between align-items-lg-center mx-0'>
                <div className='d-flex flex-row mx-0'>
                  <CheckIcon className='text-green' />
                  <p className='ml-2 mb-0'>Approved</p>
                </div>
                <Button
                  className='mt-3 mt-lg-0'
                  text='Delete'
                  icon={<TrashIcon width={15} />}
                  onClick={() => deleteReview(review._id)}
                />
              </div>
            ) : review.status === REVIEW_STATUS.Rejected ? (
              <>
                <div className='d-flex align-items-center mb-3'>
                  <RefreshIcon className='text-primary' />
                  <p className='fw-medium ml-3 mb-0'>Re Approve Review</p>
                </div>
                <div className='d-flex flex-column flex-lg-row justify-content-between align-items-lg-center mx-0'>
                  <Button
                    className='text-uppercase'
                    variant='primary'
                    size='md'
                    text='Approve'
                    onClick={() => approveReview(review)}
                  />
                  <Button
                    className='mt-3 mt-lg-0'
                    text='Delete'
                    icon={<TrashIcon width={15} />}
                    onClick={() => deleteReview(review._id)}
                  />
                </div>
              </>
            ) : (
              <div className='d-flex flex-column flex-lg-row justify-content-between align-items-lg-center mx-0'>
                <div className='d-flex flex-column flex-lg-row mx-0'>
                  <Button
                    variant='dark'
                    className='text-uppercase'
                    size='md'
                    text='Approve'
                    onClick={() => approveReview(review)}
                  />
                  <Button
                    variant='danger'
                    className='mt-3 mt-lg-0 ml-lg-2 text-uppercase'
                    size='md'
                    text='Reject'
                    onClick={() => rejectReview(review)}
                  />
                </div>
                <Button
                  className='mt-3 mt-lg-0'
                  text='Delete'
                  icon={<TrashIcon width={15} />}
                  onClick={() => deleteReview(review._id)}
                />
              </div>
            )}
          </div>
        </div>
      ))}
    </div>
  );
};

export default ReviewList;
</file>
<file name="./client/app/components/Manager/CategoryList/index.js" format="js">
/**
 *
 * CategoryList
 *
 */

import React from 'react';

import { Link } from 'react-router-dom';

const CategoryList = props => {
  const { categories } = props;

  return (
    <div className='c-list'>
      {categories.map((category, index) => (
        <Link
          to={`/dashboard/category/edit/${category._id}`}
          key={index}
          className='d-block mb-3 p-4 category-box'
        >
          <div className='d-flex align-items-center justify-content-between mb-2'>
            <h4 className='mb-0'>{category.name}</h4>
          </div>
          <p className='mb-2 category-desc'>{category.description}</p>
        </Link>
      ))}
    </div>
  );
};

export default CategoryList;
</file>
<file name="./client/app/components/Manager/OrderItems/index.js" format="js">
/**
 *
 * OrderItems
 *
 */

import React from 'react';

import { Link } from 'react-router-dom';
import { Row, Col, DropdownItem } from 'reactstrap';

import { ROLES, CART_ITEM_STATUS } from '../../../constants';
import Button from '../../Common/Button';
import DropdownConfirm from '../../Common/DropdownConfirm';

const OrderItems = props => {
  const { order, user, updateOrderItemStatus } = props;

  const renderPopoverContent = item => {
    const statuses = Object.values(CART_ITEM_STATUS);

    return (
      <div className='d-flex flex-column align-items-center justify-content-center'>
        {statuses.map((s, i) => (
          <DropdownItem
            key={`${s}-${i}`}
            className={s === item?.status ? 'active' : ''}
            onClick={() => updateOrderItemStatus(item._id, s)}
          >
            {s}
          </DropdownItem>
        ))}
      </div>
    );
  };

  const renderItemsAction = item => {
    const isAdmin = user.role === ROLES.Admin;

    if (item.status === CART_ITEM_STATUS.Delivered) {
      return (
        <Link
          to={`/product/${item.product.slug}`}
          className='btn-link text-center py-2 fs-12'
          style={{ minWidth: 120 }}
        >
          Reivew Product
        </Link>
      );
    } else if (item.status !== 'Cancelled') {
      if (!isAdmin) {
        return (
          <DropdownConfirm label='Cancel'>
            <div className='d-flex flex-column align-items-center justify-content-center p-2'>
              <p className='text-center mb-2'>{`Are you sure you want to cancel ${item.product?.name}.`}</p>
              <Button
                variant='danger'
                id='CancelOrderItemPopover'
                size='sm'
                text='Confirm Cancel'
                role='menuitem'
                className='cancel-order-btn'
                onClick={() => updateOrderItemStatus(item._id, 'Cancelled')}
              />
            </div>
          </DropdownConfirm>
        );
      } else {
        return (
          <DropdownConfirm
            label={item.product && item.status}
            className={isAdmin ? 'admin' : ''}
          >
            {renderPopoverContent(item)}
          </DropdownConfirm>
        );
      }
    }
  };

  return (
    <div className='order-items pt-3'>
      <h2>Order Items</h2>
      <Row>
        {order.products.map((item, index) => (
          <Col xs='12' key={index} className='item'>
            <div className='order-item-box'>
              <div className='d-flex justify-content-between flex-column flex-md-row'>
                <div className='d-flex align-items-center box'>
                  <img
                    className='item-image'
                    src={`${
                      item.product && item.product.imageUrl
                        ? item.product.imageUrl
                        : '/images/placeholder-image.png'
                    }`}
                  />
                  <div className='d-md-flex flex-1 align-items-start ml-4 item-box'>
                    <div className='item-details'>
                      {item.product ? (
                        <>
                          <Link
                            to={`/product/${item.product?.slug}`}
                            className='item-link'
                          >
                            <h4 className='d-block item-name one-line-ellipsis'>
                              {item.product?.name}
                            </h4>
                          </Link>
                          <div className='d-flex align-items-center justify-content-between'>
                            <span className='price'>
                              ${item.purchasePrice || item.product.price}
                            </span>
                          </div>
                        </>
                      ) : (
                        <h4>Not Available</h4>
                      )}
                    </div>
                    <div className='d-flex justify-content-between flex-wrap d-md-none mt-1'>
                      <p className='mb-1 mr-4'>
                        Status
                        <span className='order-label order-status'>{` ${item.status}`}</span>
                      </p>
                      <p className='mb-1 mr-4'>
                        Quantity
                        <span className='order-label'>{` ${item.quantity}`}</span>
                      </p>
                      <p>
                        Total Price
                        <span className='order-label'>{` $${item.totalPrice}`}</span>
                      </p>
                    </div>
                  </div>
                </div>

                <div className='d-none d-md-flex justify-content-between align-items-center box'>
                  <div className='text-center'>
                    <p className='order-label order-status'>{`${item.status}`}</p>
                    <p>Status</p>
                  </div>

                  <div className='text-center'>
                    <p className='order-label'>{` ${item.quantity}`}</p>
                    <p>Quantity</p>
                  </div>

                  <div className='text-center'>
                    <p className='order-label'>{` $${item.totalPrice}`}</p>

                    <p>Total Price</p>
                  </div>
                </div>
              </div>
              {item.product && (
                <div className='text-right mt-2 mt-md-0'>
                  {renderItemsAction(item)}
                </div>
              )}
            </div>
          </Col>
        ))}
      </Row>
    </div>
  );
};

export default OrderItems;
</file>
<file name="./client/app/components/Manager/AddBrand/index.js" format="js">
/**
 *
 * AddBrand
 *
 */

import React from 'react';

import { Row, Col } from 'reactstrap';

import Input from '../../Common/Input';
import Switch from '../../Common/Switch';
import Button from '../../Common/Button';

const AddBrand = props => {
  const { brandFormData, formErrors, brandChange, addBrand } = props;

  const handleSubmit = event => {
    event.preventDefault();
    addBrand();
  };

  return (
    <div className='add-brand'>
      <form onSubmit={handleSubmit} noValidate>
        <Row>
          <Col xs='12'>
            <Input
              type={'text'}
              error={formErrors['name']}
              label={'Name'}
              name={'name'}
              placeholder={'Brand Name'}
              value={brandFormData.name}
              onInputChange={(name, value) => {
                brandChange(name, value);
              }}
            />
          </Col>
          <Col xs='12' md='12'>
            <Input
              type={'textarea'}
              error={formErrors['description']}
              label={'Description'}
              name={'description'}
              placeholder={'Brand Description'}
              value={brandFormData.description}
              onInputChange={(name, value) => {
                brandChange(name, value);
              }}
            />
          </Col>
          <Col xs='12' md='12' className='my-2'>
            <Switch
              id={'active-brand'}
              name={'isActive'}
              label={'Active?'}
              checked={brandFormData.isActive}
              toggleCheckboxChange={value => brandChange('isActive', value)}
            />
          </Col>
        </Row>
        <hr />
        <div className='add-brand-actions'>
          <Button type='submit' text='Add Brand' />
        </div>
      </form>
    </div>
  );
};

export default AddBrand;
</file>
<file name="./client/app/components/Manager/WishList/index.js" format="js">
/**
 *
 * WishList
 *
 */

import React from 'react';

import { Link } from 'react-router-dom';

import { formatDate } from '../../../utils/date';
import Button from '../../Common/Button';
import { XIcon } from '../../Common/Icon';

const WishList = props => {
  const { wishlist, updateWishlist } = props;

  const getProductImage = item => {
    if (item.product) {
      const product = item.product;
      return (
        <div className='d-flex flex-column justify-content-center align-items-center'>
          <img
            className='item-image'
            src={`${
              product.imageUrl
                ? product.imageUrl
                : '/images/placeholder-image.png'
            }`}
          />
        </div>
      );
    }
  };

  return (
    <div className='w-list'>
      {wishlist.map((item, index) => (
        <div
          key={index}
          className='d-flex flex-row align-items-center mx-0 mb-3 wishlist-box'
        >
          <Link
            to={`/product/${item.product.slug}`}
            key={index}
            className='d-flex flex-1 align-items-center text-truncate'
          >
            {getProductImage(item)}
            <div className='d-flex flex-column justify-content-center px-3 text-truncate'>
              <h4 className='text-truncate'>{item.product.name}</h4>
              <p className='mb-2 price'>${item.product.price}</p>
              <label className='text-truncate'>{`Wishlist Added on ${formatDate(
                item.created
              )}`}</label>
            </div>
          </Link>
          <div className='remove-wishlist-box'>
            <Button
              variant='danger'
              icon={<XIcon className='text-white' width={15} />}
              round={20}
              onClick={e => {
                updateWishlist(!item.isLiked, item.product._id);
              }}
            />
          </div>
        </div>
      ))}
    </div>
  );
};

export default WishList;
</file>
<file name="./client/app/components/Manager/AddressList/index.js" format="js">
/**
 *
 * AddressList
 *
 */

import React from 'react';

import { Link } from 'react-router-dom';

import { AddressIcon, CheckIcon } from '../../Common/Icon';

const AddressList = props => {
  const { addresses } = props;

  return (
    <div className='a-list'>
      {addresses.map((address, index) => (
        <Link
          to={`/dashboard/address/edit/${address._id}`}
          key={index}
          className='d-block'
        >
          <div className='d-flex align-items-center mb-3 address-box'>
            <div className='mx-3'>
              <AddressIcon />
            </div>
            <div className='flex-1 p-3 p-lg-4'>
              {address.isDefault ? (
                <div className='d-flex align-items-center justify-content-between mb-2'>
                  <h4 className='mb-0 mr-2 one-line-ellipsis'>
                    Default Delivery Address
                  </h4>
                  <CheckIcon className='text-green' />
                </div>
              ) : (
                <h4 className='mb-0'>Delivery Address</h4>
              )}
              <p className='mb-2 address-desc'>
                {`${address?.address} ${address?.city}, ${address?.country}, ${address?.zipCode}`}
              </p>
            </div>
          </div>
        </Link>
      ))}
    </div>
  );
};

export default AddressList;
</file>
<file name="./client/app/components/Manager/AccountMenu/index.js" format="js">
/**
 *
 * AccountMenu
 *
 */

import React from 'react';

import { NavLink } from 'react-router-dom';
import { Collapse, Navbar } from 'reactstrap';

import Button from '../../Common/Button';

const AccountMenu = props => {
  const { user, isMenuOpen, links, toggleMenu } = props;

  const getAllowedProvider = link => {
    if (!link.provider) return true;

    const userProvider = user.provider ?? '';
    if (!userProvider) return true;

    return link.provider.includes(userProvider);
  };

  return (
    <div className='panel-sidebar'>
      <Button
        text='Dashboard Menu'
        className={`${isMenuOpen ? 'menu-panel' : 'menu-panel collapse'}`}
        ariaExpanded={isMenuOpen ? 'true' : 'false'}
        // ariaLabel={isMenuOpen ? 'dashboard menu expanded' : 'dashboard menu collapse'}
        onClick={toggleMenu}
      />
      <h3 className='panel-title'>Account</h3>
      <Navbar color='light' light expand='md'>
        <Collapse isOpen={isMenuOpen} navbar>
          <ul className='panel-links'>
            {links.map((link, index) => {
              const PREFIX = link.prefix ? link.prefix : '';
              const isProviderAllowed = getAllowedProvider(link);
              if (!isProviderAllowed) return;
              return (
                <li key={index}>
                  <NavLink
                    to={PREFIX + link.to}
                    activeClassName='active-link'
                    exact
                  >
                    {link.name}
                  </NavLink>
                </li>
              );
            })}
          </ul>
        </Collapse>
      </Navbar>
    </div>
  );
};

export default AccountMenu;
</file>
<file name="./client/app/components/Manager/AddMerchant/index.js" format="js">
/**
 *
 * AddMerchant
 *
 */

import React from 'react';

import { Row, Col } from 'reactstrap';

import Input from '../../Common/Input';
import Button from '../../Common/Button';

const AddMerchant = props => {
  const {
    merchantFormData,
    formErrors,
    isSubmitting,
    submitTitle = 'Submit',
    merchantChange,
    addMerchant
  } = props;

  const handleSubmit = event => {
    event.preventDefault();
    addMerchant();
  };

  return (
    <div className='add-merchant'>
      <form onSubmit={handleSubmit}>
        <Row>
          <Col xs='12'>
            <Input
              type={'text'}
              error={formErrors['name']}
              label={'Name'}
              name={'name'}
              placeholder={'Your Full Name'}
              value={merchantFormData.name}
              onInputChange={(name, value) => {
                merchantChange(name, value);
              }}
            />
          </Col>
          <Col xs='12'>
            <Input
              type={'text'}
              error={formErrors['email']}
              label={'Email Address'}
              name={'email'}
              placeholder={'Your Email Address'}
              value={merchantFormData.email}
              onInputChange={(name, value) => {
                merchantChange(name, value);
              }}
            />
          </Col>
          <Col xs='12'>
            <Input
              type={'text'}
              error={formErrors['phoneNumber']}
              label={'Phone Number'}
              name={'phoneNumber'}
              placeholder={'Your Phone Number'}
              value={merchantFormData.phoneNumber}
              onInputChange={(name, value) => {
                merchantChange(name, value);
              }}
            />
          </Col>
          <Col xs='12'>
            <Input
              type={'text'}
              error={formErrors['brandName']}
              label={'Brand'}
              name={'brandName'}
              placeholder={'Your Business Brand'}
              value={merchantFormData.brand}
              onInputChange={(name, value) => {
                merchantChange(name, value);
              }}
            />
          </Col>
          <Col xs='12'>
            <Input
              type={'textarea'}
              error={formErrors['business']}
              label={'Business'}
              name={'business'}
              placeholder={'Please Describe Your Business'}
              value={merchantFormData.business}
              onInputChange={(name, value) => {
                merchantChange(name, value);
              }}
            />
          </Col>
        </Row>
        <hr />
        <div className='add-merchant-actions'>
          <Button type='submit' text={submitTitle} disabled={isSubmitting} />
        </div>
      </form>
    </div>
  );
};

export default AddMerchant;
</file>
<file name="./client/app/components/Manager/UserList/index.js" format="js">
/**
 *
 * UserList
 *
 */

import React from 'react';

import { formatDate } from '../../../utils/date';
import UserRole from '../UserRole';

const UserList = props => {
  const { users } = props;

  return (
    <div className='u-list'>
      {users.map((user, index) => (
        <div key={index} className='mt-3 px-4 py-3 user-box'>
          <label className='text-black'>Name</label>
          <p className='fw-medium'>
            {user?.firstName ? `${user?.firstName} ${user?.lastName}` : 'N/A'}
          </p>
          <label className='text-black'>Email</label>
          <p>{user?.email ?? '-'}</p>
          <label className='text-black'>Provider</label>
          <p>{user?.provider}</p>
          <label className='text-black'>Account Created</label>
          <p>{formatDate(user?.created)}</p>
          <label className='text-black'>Role</label>
          <p className='mb-0'>
            <UserRole user={user} className='d-inline-block mt-2' />
          </p>
        </div>
      ))}
    </div>
  );
};

export default UserList;
</file>
<file name="./client/app/components/Manager/MerchantList/index.js" format="js">
/**
 *
 * MerchantList
 *
 */

import React from 'react';

import { MERCHANT_STATUS } from '../../../constants';
import { formatDate } from '../../../utils/date';
import Button from '../../Common/Button';
import { CheckIcon, XIcon, RefreshIcon, TrashIcon } from '../../Common/Icon';

const MerchantList = props => {
  const {
    merchants,
    approveMerchant,
    rejectMerchant,
    deleteMerchant,
    disableMerchant
  } = props;

  const renderMerchantPopover = merchant => (
    <div className='p-2'>
      <p className='text-gray text-14'>
        {merchant.isActive
          ? "Disabling merchant account will disable merchant's brand and account access."
          : 'Enabling merchant account will restore merchant account access.'}
      </p>
      <Button
        variant='dark'
        size='sm'
        className='w-100'
        text={merchant.isActive ? 'Disable Merchant' : 'Enable Merchant'}
        onClick={() => disableMerchant(merchant, !merchant.isActive)}
      />
    </div>
  );

  return (
    <div className='merchant-list'>
      {merchants.map((merchant, index) => (
        <div key={index} className='merchant-box'>
          <div className='mb-3 p-4'>
            <label className='text-black'>Business</label>
            <p className='fw-medium text-truncate'>{merchant.business}</p>
            <label className='text-black'>Brand</label>
            <p className='text-truncate'>{merchant.brandName}</p>
            <label className='text-black'>Name</label>
            <p className='text-truncate'>{merchant.name}</p>
            <label className='text-black'>Email</label>
            <p className='text-truncate'>
              {merchant.email ? merchant.email : 'N/A'}
            </p>
            <label className='text-black'>Phone Number</label>
            <p>{merchant.phoneNumber}</p>
            <label className='text-black'>Request date</label>
            <p>{formatDate(merchant.created)}</p>

            <hr />

            {merchant.status === MERCHANT_STATUS.Approved ? (
              <>
                <div className='d-flex flex-row justify-content-between align-items-center mx-0'>
                  <div className='d-flex flex-row mx-0'>
                    <CheckIcon className='text-green' />
                    <p className='ml-2 mb-0'>Approved</p>
                  </div>

                  <div className='d-flex flex-row align-items-center mx-0'>
                    <Button
                      className='ml-3'
                      size='lg'
                      round={20}
                      icon={<TrashIcon width={20} />}
                      tooltip={true}
                      tooltipContent='Delete'
                      id={`delete-${merchant._id}`}
                      onClick={() => deleteMerchant(merchant)}
                    />
                  </div>
                </div>
                <Button
                  className='w-100 mt-3'
                  size='sm'
                  text={
                    merchant.isActive ? 'Disable Merchant' : 'Enable Merchant'
                  }
                  popover={true}
                  popoverTitle={`Are you sure you want to ${
                    merchant.isActive ? 'disable' : 'enable'
                  } ${merchant.name}'s merchant account?`}
                  popoverContent={renderMerchantPopover(merchant)}
                />
              </>
            ) : merchant.status === MERCHANT_STATUS.Rejected ? (
              <>
                <div className='d-flex flex-row justify-content-between align-items-center mx-0'>
                  <Button
                    size='lg'
                    round={20}
                    icon={<RefreshIcon width={18} className='text-primary' />}
                    tooltip={true}
                    tooltipContent='Re-Approve'
                    id={`re-approve-${merchant._id}`}
                    onClick={() => approveMerchant(merchant)}
                  />
                  <div className='d-flex flex-row align-items-center mx-0'>
                    <Button
                      className='ml-3'
                      size='lg'
                      round={20}
                      icon={<TrashIcon width={20} />}
                      tooltip={true}
                      tooltipContent='Delete'
                      id={`delete-${merchant._id}`}
                      onClick={() => deleteMerchant(merchant)}
                    />
                  </div>
                </div>
              </>
            ) : merchant.email ? (
              <div className='d-flex flex-row justify-content-between align-items-center mx-0'>
                <div className='d-flex flex-row mx-0'>
                  <Button
                    size='lg'
                    round={20}
                    icon={<CheckIcon width={18} className='text-green' />}
                    tooltip={true}
                    tooltipContent='Approve'
                    id={`approve-${merchant._id}`}
                    onClick={() => approveMerchant(merchant)}
                  />
                  <Button
                    className='ml-2'
                    size='lg'
                    round={20}
                    icon={<XIcon width={20} />}
                    tooltip={true}
                    tooltipContent='Reject'
                    id={`reject-${merchant._id}`}
                    onClick={() => rejectMerchant(merchant)}
                  />
                </div>
                <div className='d-flex flex-row align-items-center mx-0'>
                  <Button
                    className='ml-3'
                    size='lg'
                    round={20}
                    icon={<TrashIcon width={20} />}
                    tooltip={true}
                    tooltipContent='Delete'
                    id={`delete-${merchant._id}`}
                    onClick={() => deleteMerchant(merchant)}
                  />
                </div>
              </div>
            ) : (
              <>
                <p className='text-truncate'>
                  Merchant doesn't have email. Call at
                  <a
                    href={`tel:${merchant.phoneNumber}`}
                    className='text-primary'
                  >
                    {' '}
                    {merchant.phoneNumber}
                  </a>
                </p>
                <Button
                  size='lg'
                  round={20}
                  icon={<TrashIcon width={20} />}
                  tooltip={true}
                  tooltipContent='Delete'
                  id={`delete-${merchant._id}`}
                  onClick={() => deleteMerchant(merchant)}
                />
              </>
            )}
          </div>
        </div>
      ))}
    </div>
  );
};

export default MerchantList;
</file>
<file name="./client/app/containers/Homepage/constants.js" format="js">
/*
 *
 * Homepage constants
 *
 */

export const DEFAULT_ACTION = 'src/Homepage/DEFAULT_ACTION';
</file>
<file name="./client/app/containers/Homepage/banners.json" format="json">
[
  {
    "imageUrl": "/images/banners/banner-3.jpg",
    "link": "",
    "title": "",
    "content": "<p></p>\n"
  },
  {
    "imageUrl": "/images/banners/banner-4.jpg",
    "link": "",
    "title": "",
    "content": "<p></p>\n"
  }
]
</file>
<file name="./client/app/containers/Homepage/reducer.js" format="js">
/*
 *
 * Homepage reducer
 *
 */

import { DEFAULT_ACTION } from './constants';

const initialState = {};

const homepageReducer = (state = initialState, action) => {
  let newState;
  switch (action.type) {
    case DEFAULT_ACTION:
      return newState;
    default:
      return state;
  }
};

export default homepageReducer;
</file>
<file name="./client/app/containers/Homepage/index.js" format="js">
/**
 *
 * Homepage
 *
 */

import React from 'react';

import { connect } from 'react-redux';
import { Row, Col } from 'reactstrap';

import actions from '../../actions';
import banners from './banners.json';
import CarouselSlider from '../../components/Common/CarouselSlider';
import { responsiveOneItemCarousel } from '../../components/Common/CarouselSlider/utils';

class Homepage extends React.PureComponent {
  render() {
    return (
      <div className='homepage'>
        <Row className='flex-row'>
          <Col xs='12' lg='6' className='order-lg-2 mb-3 px-3 px-md-2'>
            <div className='home-carousel'>
              <CarouselSlider
                swipeable={true}
                showDots={true}
                infinite={true}
                autoPlay={false}
                slides={banners}
                responsive={responsiveOneItemCarousel}
              >
                {banners.map((item, index) => (
                  <img key={index} src={item.imageUrl} />
                ))}
              </CarouselSlider>
            </div>
          </Col>
          <Col xs='12' lg='3' className='order-lg-1 mb-3 px-3 px-md-2'>
            <div className='d-flex flex-column h-100 justify-content-between'>
              <img src='/images/banners/banner-2.jpg' className='mb-3' />
              <img src='/images/banners/banner-5.jpg' />
            </div>
          </Col>
          <Col xs='12' lg='3' className='order-lg-3 mb-3 px-3 px-md-2'>
            <div className='d-flex flex-column h-100 justify-content-between'>
              <img src='/images/banners/banner-2.jpg' className='mb-3' />
              <img src='/images/banners/banner-6.jpg' />
            </div>
          </Col>
        </Row>
      </div>
    );
  }
}

const mapStateToProps = state => {
  return {};
};

export default connect(mapStateToProps, actions)(Homepage);
</file>
<file name="./client/app/containers/Homepage/actions.js" format="js">
/*
 *
 * Homepage actions
 *
 */

import { DEFAULT_ACTION } from './constants';

export const defaultAction = () => {
  return {
    type: DEFAULT_ACTION
  };
};
</file>
<file name="./client/app/containers/Contact/constants.js" format="js">
/*
 *
 * Contact constants
 *
 */

export const CONTACT_FORM_CHANGE = 'src/Contact/CONTACT_FORM_CHANGE';
export const SET_CONTACT_FORM_ERRORS = 'src/Contact/SET_CONTACT_FORM_ERRORS';
export const CONTACT_FORM_RESET = 'src/Contact/CONTACT_FORM_RESET';
</file>
<file name="./client/app/containers/Contact/reducer.js" format="js">
/*
 *
 * Sell reducer
 *
 */

import {
  CONTACT_FORM_CHANGE,
  SET_CONTACT_FORM_ERRORS,
  CONTACT_FORM_RESET
} from './constants';

const initialState = {
  contactFormData: {
    name: '',
    email: '',
    message: ''
  },
  formErrors: {}
};

const contactReducer = (state = initialState, action) => {
  switch (action.type) {
    case CONTACT_FORM_CHANGE:
      return {
        ...state,
        contactFormData: { ...state.contactFormData, ...action.payload }
      };
    case SET_CONTACT_FORM_ERRORS:
      return {
        ...state,
        formErrors: action.payload
      };
    case CONTACT_FORM_RESET:
      return {
        ...state,
        contactFormData: {
          name: '',
          email: '',
          message: ''
        },
        formErrors: {}
      };
    default:
      return state;
  }
};

export default contactReducer;
</file>
<file name="./client/app/containers/Contact/index.js" format="js">
/*
 *
 * Contact
 *
 */

import React from 'react';

import { connect } from 'react-redux';
import { Row, Col } from 'reactstrap';

import actions from '../../actions';

import Input from '../../components/Common/Input';
import Button from '../../components/Common/Button';

class Contact extends React.PureComponent {
  render() {
    const { contactFormData, contactFormChange, contactUs, formErrors } =
      this.props;

    const handleSubmit = event => {
      event.preventDefault();
      contactUs();
    };

    return (
      <div className='contact'>
        <h3 className='text-uppercase'>Contact Information</h3>
        <hr />
        <form onSubmit={handleSubmit}>
          <Row>
            <Col xs='12' md='6'>
              <Input
                type={'text'}
                error={formErrors['name']}
                label={'Name'}
                name={'name'}
                placeholder={'You Full Name'}
                value={contactFormData.name}
                onInputChange={(name, value) => {
                  contactFormChange(name, value);
                }}
              />
            </Col>
            <Col xs='12' md='6'>
              <Input
                type={'text'}
                error={formErrors['email']}
                label={'Email'}
                name={'email'}
                placeholder={'Your Email Address'}
                value={contactFormData.email}
                onInputChange={(name, value) => {
                  contactFormChange(name, value);
                }}
              />
            </Col>
            <Col xs='12' md='12'>
              <Input
                type={'textarea'}
                error={formErrors['message']}
                label={'Message'}
                name={'message'}
                placeholder={'Please Describe Your Message'}
                value={contactFormData.message}
                onInputChange={(name, value) => {
                  contactFormChange(name, value);
                }}
              />
            </Col>
          </Row>
          <hr />
          <div className='contact-actions'>
            <Button type='submit' text='Submit' />
          </div>
        </form>
      </div>
    );
  }
}

const mapStateToProps = state => {
  return {
    contactFormData: state.contact.contactFormData,
    formErrors: state.contact.formErrors
  };
};

export default connect(mapStateToProps, actions)(Contact);
</file>
<file name="./client/app/containers/Contact/actions.js" format="js">
/*
 *
 * Contact actions
 *
 */

import { success } from 'react-notification-system-redux';
import axios from 'axios';

import {
  CONTACT_FORM_CHANGE,
  SET_CONTACT_FORM_ERRORS,
  CONTACT_FORM_RESET
} from './constants';
import handleError from '../../utils/error';
import { allFieldsValidation } from '../../utils/validation';
import { API_URL } from '../../constants';

export const contactFormChange = (name, value) => {
  let formData = {};
  formData[name] = value;

  return {
    type: CONTACT_FORM_CHANGE,
    payload: formData
  };
};

export const contactUs = () => {
  return async (dispatch, getState) => {
    try {
      const rules = {
        name: 'required',
        email: 'required|email',
        message: 'required|min:10'
      };

      const contact = getState().contact.contactFormData;

      const { isValid, errors } = allFieldsValidation(contact, rules, {
        'required.name': 'Name is required.',
        'required.email': 'Email is required.',
        'email.email': 'Email format is invalid.',
        'required.message': 'Message is required.',
        'min.message': 'Message must be at least 10 characters.'
      });

      if (!isValid) {
        return dispatch({ type: SET_CONTACT_FORM_ERRORS, payload: errors });
      }

      const response = await axios.post(`${API_URL}/contact/add`, contact);

      const successfulOptions = {
        title: `${response.data.message}`,
        position: 'tr',
        autoDismiss: 1
      };

      dispatch({ type: CONTACT_FORM_RESET });
      dispatch(success(successfulOptions));
    } catch (error) {
      handleError(error, dispatch);
    }
  };
};
</file>
<file name="./client/app/containers/OrderSuccess/index.js" format="js">
/*
 *
 * OrderSuccess
 *
 */

import React from 'react';

import { connect } from 'react-redux';
import { Link } from 'react-router-dom';

import actions from '../../actions';

import NotFound from '../../components/Common/NotFound';
import LoadingIndicator from '../../components/Common/LoadingIndicator';

class OrderSuccess extends React.PureComponent {
  componentDidMount() {
    const id = this.props.match.params.id;
    this.props.fetchOrder(id);
  }

  componentDidUpdate(prevProps) {
    if (this.props.match.params.id !== prevProps.match.params.id) {
      const id = this.props.match.params.id;
      this.props.fetchOrder(id);
    }
  }

  render() {
    const { order, isLoading } = this.props;

    return (
      <div className='order-success'>
        {isLoading ? (
          <LoadingIndicator />
        ) : order._id ? (
          <div className='order-message'>
            <h2>Thank you for your order.</h2>
            <p>
              Order{' '}
              <Link
                to={{
                  pathname: `/order/${order._id}?success`,
                  state: { prevPath: location.pathname }
                }}
                // to={`/order/${order._id}?success`}
                className='order-label'
              >
                #{order._id}
              </Link>{' '}
              is complete.
            </p>
            <p>A confirmation email will be sent to you shortly.</p>
            <div className='order-success-actions'>
              <Link to='/dashboard/orders' className='btn-link'>
                Manage Orders
              </Link>
              <Link to='/shop' className='btn-link shopping-btn'>
                Continue Shopping
              </Link>
            </div>
          </div>
        ) : (
          <NotFound message='No order found.' />
        )}
      </div>
    );
  }
}

const mapStateToProps = state => {
  return {
    order: state.order.order,
    isLoading: state.order.isLoading
  };
};

export default connect(mapStateToProps, actions)(OrderSuccess);
</file>
<file name="./client/app/containers/Category/constants.js" format="js">
/*
 *
 * Category constants
 *
 */

export const FETCH_CATEGORIES = 'src/Category/FETCH_CATEGORIES';
export const FETCH_STORE_CATEGORIES = 'src/Category/FETCH_STORE_CATEGORIES';
export const FETCH_CATEGORY = 'src/Category/FETCH_CATEGORY';
export const CATEGORY_CHANGE = 'src/Category/CATEGORY_CHANGE';
export const CATEGORY_EDIT_CHANGE = 'src/Category/CATEGORY_EDIT_CHANGE';
export const SET_CATEGORY_FORM_ERRORS = 'src/Category/SET_CATEGORY_FORM_ERRORS';
export const SET_CATEGORY_FORM_EDIT_ERRORS =
  'src/Category/SET_CATEGORY_FORM_EDIT_ERRORS';
export const RESET_CATEGORY = 'src/Category/RESET_CATEGORY';
export const CATEGORY_SELECT = 'src/Category/CATEGORY_SELECT';
export const ADD_CATEGORY = 'src/Category/ADD_CATEGORY';
export const REMOVE_CATEGORY = 'src/Category/REMOVE_CATEGORY';
export const SET_CATEGORIES_LOADING = 'src/Product/SET_CATEGORIES_LOADING';
</file>
<file name="./client/app/containers/Category/reducer.js" format="js">
/*
 *
 * Category reducer
 *
 */

import {
  FETCH_CATEGORIES,
  FETCH_STORE_CATEGORIES,
  FETCH_CATEGORY,
  CATEGORY_CHANGE,
  CATEGORY_EDIT_CHANGE,
  SET_CATEGORY_FORM_ERRORS,
  SET_CATEGORY_FORM_EDIT_ERRORS,
  ADD_CATEGORY,
  REMOVE_CATEGORY,
  SET_CATEGORIES_LOADING,
  RESET_CATEGORY
} from './constants';

const initialState = {
  categories: [],
  storeCategories: [],
  category: {
    _id: ''
  },
  categoryFormData: {
    name: '',
    description: '',
    products: [],
    isActive: true
  },
  formErrors: {},
  editFormErrors: {},
  isLoading: false
};

const categoryReducer = (state = initialState, action) => {
  switch (action.type) {
    case FETCH_CATEGORIES:
      return {
        ...state,
        categories: action.payload
      };
    case FETCH_STORE_CATEGORIES:
      return {
        ...state,
        storeCategories: action.payload
      };
    case FETCH_CATEGORY:
      return {
        ...state,
        category: action.payload
      };
    case ADD_CATEGORY:
      return {
        ...state,
        categories: [...state.categories, action.payload]
      };
    case REMOVE_CATEGORY:
      const index = state.categories.findIndex(b => b._id === action.payload);
      return {
        ...state,
        categories: [
          ...state.categories.slice(0, index),
          ...state.categories.slice(index + 1)
        ]
      };
    case CATEGORY_CHANGE:
      return {
        ...state,
        categoryFormData: { ...state.categoryFormData, ...action.payload }
      };
    case CATEGORY_EDIT_CHANGE:
      return {
        ...state,
        category: {
          ...state.category,
          ...action.payload
        }
      };
    case SET_CATEGORY_FORM_ERRORS:
      return {
        ...state,
        formErrors: action.payload
      };
    case SET_CATEGORY_FORM_EDIT_ERRORS:
      return {
        ...state,
        editFormErrors: action.payload
      };
    case SET_CATEGORIES_LOADING:
      return {
        ...state,
        isLoading: action.payload
      };
    case RESET_CATEGORY:
      return {
        ...state,
        categoryFormData: {
          name: '',
          description: '',
          products: [],
          isActive: true
        },
        category: {
          _id: ''
        },
        formErrors: {},
        editFormErrors: {}
      };
    default:
      return state;
  }
};

export default categoryReducer;
</file>
<file name="./client/app/containers/Category/Edit.js" format="js">
/*
 *
 * Edit
 *
 */

import React from 'react';

import { connect } from 'react-redux';

import actions from '../../actions';

import EditCategory from '../../components/Manager/EditCategory';
import SubPage from '../../components/Manager/SubPage';
import NotFound from '../../components/Common/NotFound';

class Edit extends React.PureComponent {
  componentDidMount() {
    this.props.resetCategory();
    const categoryId = this.props.match.params.id;
    this.props.fetchCategory(categoryId);
    this.props.fetchProductsSelect();
  }

  componentDidUpdate(prevProps) {
    if (this.props.match.params.id !== prevProps.match.params.id) {
      this.props.resetCategory();
      const categoryId = this.props.match.params.id;
      this.props.fetchCategory(categoryId);
    }
  }

  render() {
    const {
      history,
      products,
      category,
      formErrors,
      categoryEditChange,
      updateCategory,
      deleteCategory,
      activateCategory
    } = this.props;

    return (
      <SubPage
        title='Edit Category'
        actionTitle='Cancel'
        handleAction={history.goBack}
      >
        {category?._id ? (
          <EditCategory
            products={products}
            category={category}
            formErrors={formErrors}
            categoryChange={categoryEditChange}
            updateCategory={updateCategory}
            deleteCategory={deleteCategory}
            activateCategory={activateCategory}
          />
        ) : (
          <NotFound message='No category found.' />
        )}
      </SubPage>
    );
  }
}

const mapStateToProps = state => {
  return {
    products: state.product.productsSelect,
    category: state.category.category,
    formErrors: state.category.editFormErrors
  };
};

export default connect(mapStateToProps, actions)(Edit);
</file>
<file name="./client/app/containers/Category/index.js" format="js">
/*
 *
 * Category
 *
 */

import React from 'react';

import { connect } from 'react-redux';
import { Switch, Route } from 'react-router-dom';

import actions from '../../actions';
// import { ROLES } from '../../constants';
import List from './List';
import Add from './Add';
import Edit from './Edit';
import Page404 from '../../components/Common/Page404';

class Category extends React.PureComponent {
  render() {
    const { user } = this.props;

    return (
      <div className='category-dashboard'>
        <Switch>
          <Route exact path='/dashboard/category' component={List} />
          <Route exact path='/dashboard/category/edit/:id' component={Edit} />
          {/* {user.role === ROLES.Admin && ( */}
          <Route exact path='/dashboard/category/add' component={Add} />
          {/* )} */}
          <Route path='*' component={Page404} />
        </Switch>
      </div>
    );
  }
}

const mapStateToProps = state => {
  return {
    user: state.account.user
  };
};

export default connect(mapStateToProps, actions)(Category);
</file>
<file name="./client/app/containers/Category/Add.js" format="js">
/*
 *
 * Add
 *
 */

import React from 'react';

import { connect } from 'react-redux';

import actions from '../../actions';

import AddCategory from '../../components/Manager/AddCategory';
import SubPage from '../../components/Manager/SubPage';

class Add extends React.PureComponent {
  componentDidMount() {
    this.props.fetchProductsSelect();
  }

  render() {
    const {
      history,
      products,
      categoryFormData,
      formErrors,
      categoryChange,
      addCategory
    } = this.props;

    return (
      <SubPage
        title='Add Category'
        actionTitle='Cancel'
        handleAction={() => history.goBack()}
      >
        <AddCategory
          products={products}
          categoryFormData={categoryFormData}
          formErrors={formErrors}
          categoryChange={categoryChange}
          addCategory={addCategory}
        />
      </SubPage>
    );
  }
}

const mapStateToProps = state => {
  return {
    products: state.product.productsSelect,
    categoryFormData: state.category.categoryFormData,
    formErrors: state.category.formErrors
  };
};

export default connect(mapStateToProps, actions)(Add);
</file>
<file name="./client/app/containers/Category/actions.js" format="js">
/*
 *
 * Category actions
 *
 */

import { goBack } from 'connected-react-router';
import { success } from 'react-notification-system-redux';
import axios from 'axios';

import {
  FETCH_CATEGORIES,
  FETCH_STORE_CATEGORIES,
  FETCH_CATEGORY,
  CATEGORY_CHANGE,
  CATEGORY_EDIT_CHANGE,
  SET_CATEGORY_FORM_ERRORS,
  SET_CATEGORY_FORM_EDIT_ERRORS,
  ADD_CATEGORY,
  REMOVE_CATEGORY,
  SET_CATEGORIES_LOADING,
  RESET_CATEGORY
} from './constants';

import handleError from '../../utils/error';
import { formatSelectOptions, unformatSelectOptions } from '../../utils/select';
import { allFieldsValidation } from '../../utils/validation';
import { API_URL } from '../../constants';

export const categoryChange = (name, value) => {
  let formData = {};
  formData[name] = value;

  return {
    type: CATEGORY_CHANGE,
    payload: formData
  };
};

export const categoryEditChange = (name, value) => {
  let formData = {};
  formData[name] = value;

  return {
    type: CATEGORY_EDIT_CHANGE,
    payload: formData
  };
};

export const categorySelect = value => {
  return {
    type: CATEGORY_SELECT,
    payload: value
  };
};

export const resetCategory = () => {
  return async (dispatch, getState) => {
    dispatch({ type: RESET_CATEGORY });
  };
};

// fetch store categories api
export const fetchStoreCategories = () => {
  return async (dispatch, getState) => {
    try {
      const response = await axios.get(`${API_URL}/category/list`);

      dispatch({
        type: FETCH_STORE_CATEGORIES,
        payload: response.data.categories
      });
    } catch (error) {
      handleError(error, dispatch);
    }
  };
};

// fetch categories api
export const fetchCategories = () => {
  return async (dispatch, getState) => {
    try {
      dispatch({ type: SET_CATEGORIES_LOADING, payload: true });
      const response = await axios.get(`${API_URL}/category`);

      dispatch({
        type: FETCH_CATEGORIES,
        payload: response.data.categories
      });
    } catch (error) {
      handleError(error, dispatch);
    } finally {
      dispatch({ type: SET_CATEGORIES_LOADING, payload: false });
    }
  };
};

// fetch category api
export const fetchCategory = id => {
  return async (dispatch, getState) => {
    try {
      const response = await axios.get(`${API_URL}/category/${id}`);

      response.data.category.products = formatSelectOptions(
        response.data.category.products
      );

      dispatch({
        type: FETCH_CATEGORY,
        payload: response.data.category
      });
    } catch (error) {
      handleError(error, dispatch);
    }
  };
};

// add category api
export const addCategory = () => {
  return async (dispatch, getState) => {
    try {
      const rules = {
        name: 'required',
        description: 'required|max:200',
        products: 'required'
      };

      const category = getState().category.categoryFormData;

      const newCategory = {
        name: category.name,
        description: category.description,
        products: unformatSelectOptions(category.products)
      };

      const { isValid, errors } = allFieldsValidation(newCategory, rules, {
        'required.name': 'Name is required.',
        'required.description': 'Description is required.',
        'max.description':
          'Description may not be greater than 200 characters.',
        'required.products': 'Products are required.'
      });

      if (!isValid) {
        return dispatch({ type: SET_CATEGORY_FORM_ERRORS, payload: errors });
      }

      const response = await axios.post(`${API_URL}/category/add`, newCategory);

      const successfulOptions = {
        title: `${response.data.message}`,
        position: 'tr',
        autoDismiss: 1
      };

      if (response.data.success === true) {
        dispatch(success(successfulOptions));
        dispatch({
          type: ADD_CATEGORY,
          payload: response.data.category
        });
        dispatch(resetCategory());
        dispatch(goBack());
      }
    } catch (error) {
      handleError(error, dispatch);
    }
  };
};

// update category api
export const updateCategory = () => {
  return async (dispatch, getState) => {
    try {
      const rules = {
        name: 'required',
        slug: 'required|alpha_dash',
        description: 'required|max:200',
        products: 'required'
      };

      const category = getState().category.category;

      const newCategory = {
        name: category.name,
        slug: category.slug,
        description: category.description,
        products: category.products && unformatSelectOptions(category.products)
      };

      const { isValid, errors } = allFieldsValidation(newCategory, rules, {
        'required.name': 'Name is required.',
        'required.slug': 'Slug is required.',
        'alpha_dash.slug':
          'Slug may have alpha-numeric characters, as well as dashes and underscores only.',
        'required.description': 'Description is required.',
        'max.description':
          'Description may not be greater than 200 characters.',
        'required.products': 'Products are required.'
      });

      if (!isValid) {
        return dispatch({
          type: SET_CATEGORY_FORM_EDIT_ERRORS,
          payload: errors
        });
      }

      const response = await axios.put(`${API_URL}/category/${category._id}`, {
        category: newCategory
      });

      const successfulOptions = {
        title: `${response.data.message}`,
        position: 'tr',
        autoDismiss: 1
      };

      if (response.data.success === true) {
        dispatch(success(successfulOptions));
        dispatch(resetCategory());
        dispatch(goBack());
      }
    } catch (error) {
      handleError(error, dispatch);
    }
  };
};

// activate category api
export const activateCategory = (id, value) => {
  return async (dispatch, getState) => {
    try {
      const response = await axios.put(`${API_URL}/category/${id}/active`, {
        category: {
          isActive: value
        }
      });

      const successfulOptions = {
        title: `${response.data.message}`,
        position: 'tr',
        autoDismiss: 1
      };

      if (response.data.success === true) {
        dispatch(success(successfulOptions));
      }
    } catch (error) {
      handleError(error, dispatch);
    }
  };
};

// delete category api
export const deleteCategory = id => {
  return async (dispatch, getState) => {
    try {
      const response = await axios.delete(`${API_URL}/category/delete/${id}`);

      const successfulOptions = {
        title: `${response.data.message}`,
        position: 'tr',
        autoDismiss: 1
      };

      if (response.data.success == true) {
        dispatch(success(successfulOptions));
        dispatch({
          type: REMOVE_CATEGORY,
          payload: id
        });
        dispatch(goBack());
      }
    } catch (error) {
      handleError(error, dispatch);
    }
  };
};
</file>
<file name="./client/app/containers/Category/List.js" format="js">
/*
 *
 * List
 *
 */

import React from 'react';

import { connect } from 'react-redux';

import actions from '../../actions';

import CategoryList from '../../components/Manager/CategoryList';
import SubPage from '../../components/Manager/SubPage';
import LoadingIndicator from '../../components/Common/LoadingIndicator';
import NotFound from '../../components/Common/NotFound';

class List extends React.PureComponent {
  componentDidMount() {
    this.props.fetchCategories();
  }

  render() {
    const { history, categories, isLoading } = this.props;

    return (
      <>
        <SubPage
          title='Categories'
          actionTitle='Add'
          handleAction={() => history.push('/dashboard/category/add')}
        >
          {isLoading ? (
            <LoadingIndicator inline />
          ) : categories.length > 0 ? (
            <CategoryList categories={categories} />
          ) : (
            <NotFound message='No categories found.' />
          )}
        </SubPage>
      </>
    );
  }
}

const mapStateToProps = state => {
  return {
    categories: state.category.categories,
    isLoading: state.category.isLoading,
    user: state.account.user
  };
};

export default connect(mapStateToProps, actions)(List);
</file>
<file name="./client/app/containers/NavigationMenu/constants.js" format="js">
/*
 *
 * NavigationMenu constants
 *
 */

export const DEFAULT_ACTION = 'src/NavigationMenu/DEFAULT_ACTION';
</file>
<file name="./client/app/containers/NavigationMenu/reducer.js" format="js">
/*
 *
 * NavigationMenu reducer
 *
 */

import { DEFAULT_ACTION } from './constants';

const initialState = {};

const navigationMenuReducer = (state = initialState, action) => {
  switch (action.type) {
    case DEFAULT_ACTION:
      return {
        ...state
      };
    default:
      return state;
  }
};

export default navigationMenuReducer;
</file>
<file name="./client/app/containers/NavigationMenu/index.js" format="js">
/**
 *
 * NavigationMenu
 *
 */

import React from 'react';

import { connect } from 'react-redux';
import { NavLink } from 'react-router-dom';
import { Container } from 'reactstrap';

import actions from '../../actions';

import Button from '../../components/Common/Button';
import { CloseIcon } from '../../components/Common/Icon';

class NavigationMenu extends React.PureComponent {
  render() {
    const { isMenuOpen, categories, toggleMenu } = this.props;

    const handleCategoryClick = () => {
      this.props.toggleMenu();
    };

    return (
      <div className='navigation-menu'>
        <div className='menu-header'>
          {isMenuOpen && (
            <Button
              borderless
              variant='empty'
              ariaLabel='close the menu'
              icon={<CloseIcon />}
              onClick={toggleMenu}
            />
          )}
        </div>
        <div className='menu-body'>
          <Container>
            <h3 className='menu-title'>Shop By Category</h3>
            <nav role='navigation'>
              <ul className='menu-list'>
                {categories.map((link, index) => (
                  <li key={index} className='menu-item'>
                    <NavLink
                      onClick={handleCategoryClick}
                      to={'/shop/category/' + link.slug}
                      activeClassName='active-link'
                      exact
                    >
                      {link.name}
                    </NavLink>
                  </li>
                ))}
              </ul>
            </nav>
          </Container>
        </div>
      </div>
    );
  }
}

const mapStateToProps = state => {
  return {
    isMenuOpen: state.navigation.isMenuOpen,
    categories: state.category.storeCategories
  };
};

export default connect(mapStateToProps, actions)(NavigationMenu);
</file>
<file name="./client/app/containers/NavigationMenu/actions.js" format="js">
/*
 *
 * NavigationMenu actions
 *
 */

import { DEFAULT_ACTION } from './constants';

export const defaultAction = () => {
  return {
    type: DEFAULT_ACTION
  };
};
</file>
<file name="./client/app/containers/OrderPage/index.js" format="js">
/**
 *
 * OrderPage
 *
 */

import React from 'react';

import { connect } from 'react-redux';

import actions from '../../actions';

import OrderDetails from '../../components/Manager/OrderDetails';
import NotFound from '../../components/Common/NotFound';
import LoadingIndicator from '../../components/Common/LoadingIndicator';

class OrderPage extends React.PureComponent {
  componentDidMount() {
    const id = this.props.match.params.id;
    this.props.fetchOrder(id);
  }

  componentDidUpdate(prevProps) {
    if (this.props.match.params.id !== prevProps.match.params.id) {
      const id = this.props.match.params.id;
      this.props.fetchOrder(id);
    }
  }

  render() {
    const {
      history,
      order,
      user,
      isLoading,
      cancelOrder,
      updateOrderItemStatus
    } = this.props;

    return (
      <div className='order-page'>
        {isLoading ? (
          <LoadingIndicator backdrop />
        ) : order._id ? (
          <OrderDetails
            order={order}
            user={user}
            cancelOrder={cancelOrder}
            updateOrderItemStatus={updateOrderItemStatus}
            onBack={() => {
              if (window.location.toString().includes('success')) {
                history.push('/dashboard/orders');
              } else {
                history.goBack();
              }
            }}
          />
        ) : (
          <NotFound message='No order found.' />
        )}
      </div>
    );
  }
}

const mapStateToProps = state => {
  return {
    user: state.account.user,
    order: state.order.order,
    isLoading: state.order.isLoading
  };
};

export default connect(mapStateToProps, actions)(OrderPage);
</file>
<file name="./client/app/containers/ForgotPassword/constants.js" format="js">
/*
 *
 * ForgotPassword constants
 *
 */

export const FORGOT_PASSWORD_CHANGE =
  'src/ForgotPassword/FORGOT_PASSWORD_CHANGE';
export const FORGOT_PASSWORD_RESET = 'src/ForgotPassword/FORGOT_PASSWORD_RESET';
export const SET_FORGOT_PASSWORD_FORM_ERRORS =
  'src/ForgotPassword/SET_FORGOT_PASSWORD_FORM_ERRORS';
</file>
<file name="./client/app/containers/ForgotPassword/reducer.js" format="js">
/*
 *
 * ForgotPassword reducer
 *
 */

import {
  FORGOT_PASSWORD_CHANGE,
  FORGOT_PASSWORD_RESET,
  SET_FORGOT_PASSWORD_FORM_ERRORS
} from './constants';

const initialState = {
  forgotFormData: {
    email: ''
  },
  formErrors: {}
};

const forgotPasswordReducer = (state = initialState, action) => {
  switch (action.type) {
    case FORGOT_PASSWORD_CHANGE:
      return {
        ...state,
        forgotFormData: {
          email: action.payload
        }
      };
    case SET_FORGOT_PASSWORD_FORM_ERRORS:
      return {
        ...state,
        formErrors: action.payload
      };
    case FORGOT_PASSWORD_RESET:
      return {
        ...state,
        forgotFormData: {
          email: ''
        }
      };
    default:
      return state;
  }
};

export default forgotPasswordReducer;
</file>
<file name="./client/app/containers/ForgotPassword/index.js" format="js">
/*
 *
 * ForgotPassword
 *
 */

import React from 'react';
import { connect } from 'react-redux';

import { Row, Col } from 'reactstrap';
import { Redirect, Link } from 'react-router-dom';

import actions from '../../actions';

import Input from '../../components/Common/Input';
import Button from '../../components/Common/Button';

class ForgotPassword extends React.PureComponent {
  render() {
    const {
      authenticated,
      forgotFormData,
      formErrors,
      forgotPasswordChange,
      forgotPassowrd
    } = this.props;

    if (authenticated) return <Redirect to='/dashboard' />;

    const handleSubmit = event => {
      event.preventDefault();
      forgotPassowrd();
    };

    return (
      <div className='forgot-password-form'>
        <h3>Forgot Password</h3>
        <hr />
        <form onSubmit={handleSubmit}>
          <Row>
            <Col xs='12' md='6'>
              <Input
                type={'text'}
                error={formErrors['email']}
                label={'Email Address'}
                name={'email'}
                placeholder={'Please Enter Your Email'}
                value={forgotFormData.email}
                onInputChange={(name, value) => {
                  forgotPasswordChange(name, value);
                }}
              />
            </Col>
          </Row>
          <hr />
          <div className='d-flex flex-column flex-md-row align-items-md-center justify-content-between'>
            <Button
              type='submit'
              variant='primary'
              text='Send Email'
              className='mb-3 mb-md-0'
            />
            <Link className='redirect-link' to={'/login'}>
              Back to login
            </Link>
          </div>
        </form>
      </div>
    );
  }
}

const mapStateToProps = state => {
  return {
    authenticated: state.authentication.authenticated,
    forgotFormData: state.forgotPassword.forgotFormData,
    formErrors: state.forgotPassword.formErrors
  };
};

export default connect(mapStateToProps, actions)(ForgotPassword);
</file>
<file name="./client/app/containers/ForgotPassword/actions.js" format="js">
/*
 *
 * ForgotPassword actions
 *
 */

import { push } from 'connected-react-router';
import { success } from 'react-notification-system-redux';
import axios from 'axios';

import {
  FORGOT_PASSWORD_CHANGE,
  FORGOT_PASSWORD_RESET,
  SET_FORGOT_PASSWORD_FORM_ERRORS
} from './constants';
import handleError from '../../utils/error';
import { allFieldsValidation } from '../../utils/validation';
import { API_URL } from '../../constants';

export const forgotPasswordChange = (name, value) => {
  return {
    type: FORGOT_PASSWORD_CHANGE,
    payload: value
  };
};

export const forgotPassowrd = () => {
  return async (dispatch, getState) => {
    try {
      const rules = {
        email: 'required|email'
      };

      const user = getState().forgotPassword.forgotFormData;

      const { isValid, errors } = allFieldsValidation(user, rules, {
        'required.email': 'Email is required.'
      });

      if (!isValid) {
        return dispatch({
          type: SET_FORGOT_PASSWORD_FORM_ERRORS,
          payload: errors
        });
      }

      const response = await axios.post(`${API_URL}/auth/forgot`, user);
      const successfulOptions = {
        title: `${response.data.message}`,
        position: 'tr',
        autoDismiss: 1
      };

      if (response.data.success === true) {
        dispatch(push('/login'));
      }
      dispatch(success(successfulOptions));

      dispatch({ type: FORGOT_PASSWORD_RESET });
    } catch (error) {
      const title = `Please try again!`;
      handleError(error, dispatch, title);
    }
  };
};
</file>
<file name="./client/app/containers/ResetPassword/constants.js" format="js">
/*
 *
 * ResetPassword constants
 *
 */

export const RESET_PASSWORD_CHANGE = 'src/ResetPassword/RESET_PASSWORD_CHANGE';
export const RESET_PASSWORD_RESET = 'src/ResetPassword/RESET_PASSWORD_RESET';
export const SET_RESET_PASSWORD_FORM_ERRORS =
  'src/ResetPassword/SET_RESET_PASSWORD_FORM_ERRORS';
</file>
<file name="./client/app/containers/ResetPassword/reducer.js" format="js">
/*
 *
 * ResetPassword reducer
 *
 */

import {
  RESET_PASSWORD_CHANGE,
  RESET_PASSWORD_RESET,
  SET_RESET_PASSWORD_FORM_ERRORS
} from './constants';

const initialState = {
  resetFormData: {
    password: '',
    confirmPassword: ''
  },
  formErrors: {}
};

const resetPasswordReducer = (state = initialState, action) => {
  switch (action.type) {
    case RESET_PASSWORD_CHANGE:
      return {
        ...state,
        resetFormData: { ...state.resetFormData, ...action.payload }
      };
    case SET_RESET_PASSWORD_FORM_ERRORS:
      return {
        ...state,
        formErrors: action.payload
      };
    case RESET_PASSWORD_RESET:
      return {
        ...state,
        resetFormData: {
          password: '',
          confirmPassword: ''
        },
        formErrors: {}
      };
    default:
      return state;
  }
};

export default resetPasswordReducer;
</file>
<file name="./client/app/containers/ResetPassword/index.js" format="js">
/*
 *
 * ResetPassword
 *
 */

import React from 'react';

import { connect } from 'react-redux';
import { Redirect } from 'react-router-dom';

import actions from '../../actions';
import ResetPasswordForm from '../../components/Common/ResetPasswordForm';

class ResetPassword extends React.PureComponent {
  handleResetPassword() {
    const token = this.props.match.params.token;
    this.props.resetPassword(token);
  }

  render() {
    const { authenticated, resetFormData, formErrors, resetPasswordChange } =
      this.props;

    if (authenticated) return <Redirect to='/dashboard' />;

    return (
      <div className='reset-password-form'>
        <h2>Reset Password</h2>
        <hr />
        <ResetPasswordForm
          isToken
          resetFormData={resetFormData}
          formErrors={formErrors}
          resetPasswordChange={resetPasswordChange}
          resetPassword={() => this.handleResetPassword()}
        />
      </div>
    );
  }
}

const mapStateToProps = state => {
  return {
    authenticated: state.authentication.authenticated,
    resetFormData: state.resetPassword.resetFormData,
    formErrors: state.resetPassword.formErrors
  };
};

export default connect(mapStateToProps, actions)(ResetPassword);
</file>
<file name="./client/app/containers/ResetPassword/actions.js" format="js">
/*
 *
 * ResetPassword actions
 *
 */

import { push } from 'connected-react-router';
import { success } from 'react-notification-system-redux';
import axios from 'axios';

import {
  RESET_PASSWORD_CHANGE,
  RESET_PASSWORD_RESET,
  SET_RESET_PASSWORD_FORM_ERRORS
} from './constants';

import { signOut } from '../Login/actions';
import handleError from '../../utils/error';
import { allFieldsValidation } from '../../utils/validation';
import { API_URL } from '../../constants';

export const resetPasswordChange = (name, value) => {
  let formData = {};
  formData[name] = value;

  return {
    type: RESET_PASSWORD_CHANGE,
    payload: formData
  };
};

export const resetPassword = token => {
  return async (dispatch, getState) => {
    try {
      const rules = {
        password: 'required|min:6',
        confirmPassword: 'required|min:6|same:password'
      };
      const user = getState().resetPassword.resetFormData;

      const { isValid, errors } = allFieldsValidation(user, rules, {
        'required.password': 'Password is required.',
        'min.password': 'Password must be at least 6 characters.',
        'required.confirmPassword': 'Confirm password is required.',
        'min.confirmPassword':
          'Confirm password must be at least 6 characters.',
        'same.confirmPassword':
          'Confirm password and password fields must match.'
      });

      if (!isValid) {
        return dispatch({
          type: SET_RESET_PASSWORD_FORM_ERRORS,
          payload: errors
        });
      }

      const response = await axios.post(`${API_URL}/auth/reset/${token}`, user);
      const successfulOptions = {
        title: `${response.data.message}`,
        position: 'tr',
        autoDismiss: 1
      };

      if (response.data.success == true) {
        dispatch(push('/login'));
      }

      dispatch(success(successfulOptions));
      dispatch({ type: RESET_PASSWORD_RESET });
    } catch (error) {
      const title = `Please try to reset again!`;
      handleError(error, dispatch, title);
    }
  };
};

export const resetAccountPassword = () => {
  return async (dispatch, getState) => {
    try {
      const rules = {
        password: 'required|min:6',
        confirmPassword: 'required|min:6'
      };

      const user = getState().resetPassword.resetFormData;

      const { isValid, errors } = allFieldsValidation(user, rules, {
        'required.password': 'Password is required.',
        'min.password': 'Password must be at least 6 characters.',
        'required.confirmPassword': 'Confirm password is required.',
        'min.confirmPassword': 'Confirm password must be at least 6 characters.'
      });

      if (!isValid) {
        return dispatch({
          type: SET_RESET_PASSWORD_FORM_ERRORS,
          payload: errors
        });
      }

      const response = await axios.post(`${API_URL}/auth/reset`, user);
      const successfulOptions = {
        title: `${response.data.message}`,
        position: 'tr',
        autoDismiss: 1
      };

      if (response.data.success === true) {
        dispatch(signOut());
      }

      dispatch(success(successfulOptions));
      dispatch({ type: RESET_PASSWORD_RESET });
    } catch (error) {
      const title = `Please try to reset again!`;
      handleError(error, dispatch, title);
    }
  };
};
</file>
<file name="./client/app/containers/Support/index.js" format="js">
/*
 *
 * Support
 *
 */

import React from 'react';
import { connect } from 'react-redux';

import actions from '../../actions';

import { default as SupportManager } from '../../components/Manager/Support';

class Support extends React.PureComponent {
  render() {
    const { user } = this.props;

    return (
      <div className='support'>
        <h3>Support</h3>
        <hr />
        <div className='mt-5'>
          <SupportManager user={user} />
        </div>
      </div>
    );
  }
}

const mapStateToProps = state => {
  return {
    user: state.account.user,
    resetFormData: state.resetPassword.resetFormData,
    formErrors: state.resetPassword.formErrors
  };
};

export default connect(mapStateToProps, actions)(Support);
</file>
<file name="./client/app/containers/Authentication/constants.js" format="js">
/*
 *
 * Authentication constants
 *
 */

export const SET_AUTH = 'src/Authentication/SET_AUTH';
export const CLEAR_AUTH = 'src/Authentication/CLEAR_AUTH';
</file>
<file name="./client/app/containers/Authentication/reducer.js" format="js">
/*
 *
 * Authentication reducer
 *
 */

import { SET_AUTH, CLEAR_AUTH } from './constants';

const initialState = {
  authenticated: false,
  isLoading: false
};

const authenticationReducer = (state = initialState, action) => {
  switch (action.type) {
    case SET_AUTH:
      return {
        ...state,
        authenticated: true
      };
    case CLEAR_AUTH:
      return {
        ...state,
        authenticated: false
      };
    default:
      return state;
  }
};

export default authenticationReducer;
</file>
<file name="./client/app/containers/Authentication/index.js" format="js">
/**
 *
 * Authentication
 *
 */

import React from 'react';

import { connect } from 'react-redux';
import { Redirect } from 'react-router-dom';

import actions from '../../actions';

export default function (ComposedComponent) {
  class Authentication extends React.PureComponent {
    render() {
      const { authenticated } = this.props;

      if (!authenticated) {
        return <Redirect to='/login' />;
      } else {
        return <ComposedComponent {...this.props} />;
      }
    }
  }

  const mapStateToProps = state => {
    return {
      authenticated: state.authentication.authenticated
    };
  };

  return connect(mapStateToProps, actions)(Authentication);
}
</file>
<file name="./client/app/containers/Authentication/actions.js" format="js">
/*
 *
 * Authentication actions
 *
 */

import { SET_AUTH, CLEAR_AUTH } from './constants';

export const setAuth = () => {
  return {
    type: SET_AUTH
  };
};

export const clearAuth = () => {
  return {
    type: CLEAR_AUTH
  };
};
</file>
<file name="./client/app/containers/Account/constants.js" format="js">
/*
 *
 * Account constants
 *
 */

export const ACCOUNT_CHANGE = 'src/Account/ACCOUNT_CHANGE';
export const FETCH_PROFILE = 'src/Account/FETCH_PROFILE';
export const CLEAR_ACCOUNT = 'src/Account/CLEAR_ACCOUNT';
export const SET_PROFILE_LOADING = 'src/Account/SET_PROFILE_LOADING';
</file>
<file name="./client/app/containers/Account/reducer.js" format="js">
/*
 *
 * Account reducer
 *
 */

import {
  ACCOUNT_CHANGE,
  FETCH_PROFILE,
  CLEAR_ACCOUNT,
  SET_PROFILE_LOADING
} from './constants';

const initialState = {
  user: {
    firstName: '',
    lastName: '',
    provider: '',
    role: ''
  },
  isLoading: false
};

const accountReducer = (state = initialState, action) => {
  switch (action.type) {
    case ACCOUNT_CHANGE:
      return {
        ...state,
        user: {
          ...state.user,
          ...action.payload
        }
      };
    case FETCH_PROFILE:
      return {
        ...state,
        user: {
          ...state.user,
          ...action.payload
        }
      };
    case CLEAR_ACCOUNT:
      return {
        ...state,
        user: {
          firstName: '',
          lastName: ''
        }
      };
    case SET_PROFILE_LOADING:
      return {
        ...state,
        isLoading: action.payload
      };
    default:
      return state;
  }
};

export default accountReducer;
</file>
<file name="./client/app/containers/Account/index.js" format="js">
/*
 *
 * Account
 *
 */

import React from 'react';
import { connect } from 'react-redux';

import actions from '../../actions';

import AccountDetails from '../../components/Manager/AccountDetails';
import SubPage from '../../components/Manager/SubPage';

class Account extends React.PureComponent {
  componentDidMount() {
    // this.props.fetchProfile();
  }

  render() {
    const { user, accountChange, updateProfile } = this.props;

    return (
      <div className='account'>
        <SubPage title={'Account Details'} isMenuOpen={null}>
          <AccountDetails
            user={user}
            accountChange={accountChange}
            updateProfile={updateProfile}
          />
        </SubPage>
      </div>
    );
  }
}

const mapStateToProps = state => {
  return {
    user: state.account.user,
    resetFormData: state.resetPassword.resetFormData,
    formErrors: state.resetPassword.formErrors
  };
};

export default connect(mapStateToProps, actions)(Account);
</file>
<file name="./client/app/containers/Account/actions.js" format="js">
/*
 *
 * Account actions
 *
 */

import { success } from 'react-notification-system-redux';
import axios from 'axios';

import {
  ACCOUNT_CHANGE,
  FETCH_PROFILE,
  CLEAR_ACCOUNT,
  SET_PROFILE_LOADING
} from './constants';
import handleError from '../../utils/error';
import { API_URL } from '../../constants';

export const accountChange = (name, value) => {
  let formData = {};
  formData[name] = value;

  return {
    type: ACCOUNT_CHANGE,
    payload: formData
  };
};

export const clearAccount = () => {
  return {
    type: CLEAR_ACCOUNT
  };
};

export const setProfileLoading = value => {
  return {
    type: SET_PROFILE_LOADING,
    payload: value
  };
};

export const fetchProfile = () => {
  return async (dispatch, getState) => {
    try {
      dispatch(setProfileLoading(true));
      const response = await axios.get(`${API_URL}/user/me`);

      dispatch({ type: FETCH_PROFILE, payload: response.data.user });
    } catch (error) {
      handleError(error, dispatch);
    } finally {
      dispatch(setProfileLoading(false));
    }
  };
};

export const updateProfile = () => {
  return async (dispatch, getState) => {
    const profile = getState().account.user;

    try {
      const response = await axios.put(`${API_URL}/user`, {
        profile
      });

      const successfulOptions = {
        title: `${response.data.message}`,
        position: 'tr',
        autoDismiss: 1
      };

      dispatch({ type: FETCH_PROFILE, payload: response.data.user });

      dispatch(success(successfulOptions));
    } catch (error) {
      handleError(error, dispatch);
    }
  };
};
</file>
<file name="./client/app/containers/Login/constants.js" format="js">
/*
 *
 * Login constants
 *
 */

export const LOGIN_CHANGE = 'src/Login/LOGIN_CHANGE';
export const LOGIN_RESET = 'src/Login/LOGIN_RESET';
export const SET_LOGIN_LOADING = 'src/Login/SET_LOGIN_LOADING';
export const SET_LOGIN_FORM_ERRORS = 'src/Login/SET_LOGIN_FORM_ERRORS';
export const SET_LOGIN_SUBMITTING = 'src/Login/SET_LOGIN_SUBMITTING';
</file>
<file name="./client/app/containers/Login/reducer.js" format="js">
/*
 *
 * Login reducer
 *
 */

import {
  LOGIN_CHANGE,
  LOGIN_RESET,
  SET_LOGIN_LOADING,
  SET_LOGIN_FORM_ERRORS,
  SET_LOGIN_SUBMITTING
} from './constants';

const initialState = {
  loginFormData: {
    email: '',
    password: ''
  },
  formErrors: {},
  isSubmitting: false,
  isLoading: false
};

const loginReducer = (state = initialState, action) => {
  switch (action.type) {
    case LOGIN_CHANGE:
      return {
        ...state,
        loginFormData: { ...state.loginFormData, ...action.payload }
      };
    case SET_LOGIN_FORM_ERRORS:
      return {
        ...state,
        formErrors: action.payload
      };
    case SET_LOGIN_LOADING:
      return {
        ...state,
        isLoading: action.payload
      };
    case SET_LOGIN_SUBMITTING:
      return {
        ...state,
        isSubmitting: action.payload
      };
    case LOGIN_RESET:
      return {
        ...state,
        loginFormData: {
          email: '',
          password: ''
        },
        formErrors: {},
        isLoading: false
      };
    default:
      return state;
  }
};

export default loginReducer;
</file>
<file name="./client/app/containers/Login/index.js" format="js">
/*
 *
 * Login
 *
 */

import React from 'react';

import { connect } from 'react-redux';
import { Redirect, Link } from 'react-router-dom';
import { Row, Col } from 'reactstrap';

import actions from '../../actions';

import Input from '../../components/Common/Input';
import Button from '../../components/Common/Button';
import LoadingIndicator from '../../components/Common/LoadingIndicator';
import SignupProvider from '../../components/Common/SignupProvider';

class Login extends React.PureComponent {
  render() {
    const {
      authenticated,
      loginFormData,
      loginChange,
      login,
      formErrors,
      isLoading,
      isSubmitting
    } = this.props;

    if (authenticated) return <Redirect to='/dashboard' />;

    const registerLink = () => {
      this.props.history.push('/register');
    };

    const handleSubmit = event => {
      event.preventDefault();
      login();
    };

    return (
      <div className='login-form'>
        {isLoading && <LoadingIndicator />}
        <h2>Login</h2>
        <hr />
        <form onSubmit={handleSubmit} noValidate>
          <Row>
            <Col
              xs={{ size: 12, order: 2 }}
              md={{ size: '6', order: 1 }}
              className='p-0'
            >
              <Col xs='12' md='12'>
                <Input
                  type={'text'}
                  error={formErrors['email']}
                  label={'Email Address'}
                  name={'email'}
                  placeholder={'Please Enter Your Email'}
                  value={loginFormData.email}
                  onInputChange={(name, value) => {
                    loginChange(name, value);
                  }}
                />
              </Col>
              <Col xs='12' md='12'>
                <Input
                  type={'password'}
                  error={formErrors['password']}
                  label={'Password'}
                  name={'password'}
                  placeholder={'Please Enter Your Password'}
                  value={loginFormData.password}
                  onInputChange={(name, value) => {
                    loginChange(name, value);
                  }}
                />
              </Col>
            </Col>
            <Col
              xs={{ size: 12, order: 1 }}
              md={{ size: '6', order: 2 }}
              className='mb-2 mb-md-0'
            >
              <SignupProvider />
            </Col>
          </Row>
          <hr />
          <div className='d-flex flex-column flex-md-row align-items-md-center justify-content-between'>
            <div className='d-flex justify-content-between align-items-center mb-3 mb-md-0'>
              <Button
                type='submit'
                variant='primary'
                text='Login'
                disabled={isSubmitting}
              />
              <Button
                text='Create an account'
                variant='link'
                className='ml-md-3'
                onClick={registerLink}
              />
            </div>
            <Link
              className='redirect-link forgot-password-link'
              to={'/forgot-password'}
            >
              Forgot Password?
            </Link>
          </div>
        </form>
      </div>
    );
  }
}

const mapStateToProps = state => {
  return {
    authenticated: state.authentication.authenticated,
    loginFormData: state.login.loginFormData,
    formErrors: state.login.formErrors,
    isLoading: state.login.isLoading,
    isSubmitting: state.login.isSubmitting
  };
};

export default connect(mapStateToProps, actions)(Login);
</file>
<file name="./client/app/containers/Login/actions.js" format="js">
/*
 *
 * Login actions
 *
 */

import { success } from 'react-notification-system-redux';
import axios from 'axios';
import { push } from 'connected-react-router';

import {
  LOGIN_CHANGE,
  LOGIN_RESET,
  SET_LOGIN_LOADING,
  SET_LOGIN_FORM_ERRORS,
  SET_LOGIN_SUBMITTING
} from './constants';
import { setAuth, clearAuth } from '../Authentication/actions';
import setToken from '../../utils/token';
import handleError from '../../utils/error';
import { clearCart } from '../Cart/actions';
import { clearAccount } from '../Account/actions';
import { allFieldsValidation } from '../../utils/validation';
import { API_URL } from '../../constants';

export const loginChange = (name, value) => {
  let formData = {};
  formData[name] = value;

  return {
    type: LOGIN_CHANGE,
    payload: formData
  };
};

export const login = () => {
  return async (dispatch, getState) => {
    const rules = {
      email: 'required|email',
      password: 'required|min:6'
    };

    const user = getState().login.loginFormData;

    const { isValid, errors } = allFieldsValidation(user, rules, {
      'required.email': 'Email is required.',
      'email.email': 'Email format is invalid.',
      'required.password': 'Password is required.',
      'min.password': 'Password must be at least 6 characters.'
    });

    if (!isValid) {
      return dispatch({ type: SET_LOGIN_FORM_ERRORS, payload: errors });
    }

    dispatch({ type: SET_LOGIN_SUBMITTING, payload: true });
    dispatch({ type: SET_LOGIN_LOADING, payload: true });

    try {
      const response = await axios.post(`${API_URL}/auth/login`, user);

      const firstName = response.data.user.firstName;

      const successfulOptions = {
        title: `Hey${firstName ? ` ${firstName}` : ''}, Welcome Back!`,
        position: 'tr',
        autoDismiss: 1
      };

      localStorage.setItem('token', response.data.token);

      setToken(response.data.token);

      dispatch(setAuth());
      dispatch(success(successfulOptions));

      dispatch({ type: LOGIN_RESET });
    } catch (error) {
      const title = `Please try to login again!`;
      handleError(error, dispatch, title);
    } finally {
      dispatch({ type: SET_LOGIN_SUBMITTING, payload: false });
      dispatch({ type: SET_LOGIN_LOADING, payload: false });
    }
  };
};

export const signOut = () => {
  return (dispatch, getState) => {
    const successfulOptions = {
      title: `You have signed out!`,
      position: 'tr',
      autoDismiss: 1
    };

    dispatch(clearAuth());
    dispatch(clearAccount());
    dispatch(push('/login'));

    localStorage.removeItem('token');

    dispatch(success(successfulOptions));
    // dispatch(clearCart());
  };
};
</file>
<file name="./client/app/containers/Dashboard/constants.js" format="js">
/*
 *
 * Dashboard constants
 *
 */

export const TOGGLE_DASHBOARD_MENU = 'src/Dashboard/TOGGLE_DASHBOARD_MENU';
</file>
<file name="./client/app/containers/Dashboard/reducer.js" format="js">
/*
 *
 * Dashboard reducer
 *
 */

import { TOGGLE_DASHBOARD_MENU } from './constants';

const initialState = {
  isMenuOpen: false
};

const dashboardReducer = (state = initialState, action) => {
  switch (action.type) {
    case TOGGLE_DASHBOARD_MENU:
      return {
        ...state,
        isMenuOpen: !state.isMenuOpen
      };
    default:
      return state;
  }
};

export default dashboardReducer;
</file>
<file name="./client/app/containers/Dashboard/links.json" format="json">
{
  "ROLE ADMIN": [
    { "to": "", "name": "Account Details", "prefix": "/dashboard" },
    {
      "to": "/security",
      "name": "Account Security",
      "prefix": "/dashboard",
      "provider": ["Email"]
    },
    { "to": "/address", "name": "Address", "prefix": "/dashboard" },
    { "to": "/product", "name": "Products", "prefix": "/dashboard" },
    { "to": "/category", "name": "Categories", "prefix": "/dashboard" },
    { "to": "/brand", "name": "Brand", "prefix": "/dashboard" },
    { "to": "/users", "name": "Users", "prefix": "/dashboard" },
    { "to": "/merchant", "name": "Merchants", "prefix": "/dashboard" },
    { "to": "/orders", "name": "Orders", "prefix": "/dashboard" },
    { "to": "/review", "name": "Reviews", "prefix": "/dashboard" },
    { "to": "/wishlist", "name": "WishList", "prefix": "/dashboard" },
    { "to": "/support", "name": "Support" }
  ],
  "ROLE MERCHANT": [
    { "to": "", "name": "Account Details", "prefix": "/dashboard" },
    {
      "to": "/security",
      "name": "Account Security",
      "prefix": "/dashboard",
      "provider": ["Email"]
    },
    { "to": "/address", "name": "Address", "prefix": "/dashboard" },
    { "to": "/brand", "name": "Brand", "prefix": "/dashboard" },
    { "to": "/product", "name": "Products", "prefix": "/dashboard" },
    { "to": "/orders", "name": "Orders", "prefix": "/dashboard" },
    { "to": "/wishlist", "name": "WishList", "prefix": "/dashboard" },
    { "to": "/support", "name": "Support" }
  ],
  "ROLE MEMBER": [
    { "to": "", "name": "Account Details", "prefix": "/dashboard" },
    {
      "to": "/security",
      "name": "Account Security",
      "prefix": "/dashboard",
      "provider": ["Email"]
    },
    { "to": "/address", "name": "Address", "prefix": "/dashboard" },
    { "to": "/orders", "name": "Orders", "prefix": "/dashboard" },
    { "to": "/wishlist", "name": "WishList", "prefix": "/dashboard" },
    { "to": "/support", "name": "Support" }
  ]
}
</file>
<file name="./client/app/containers/Dashboard/index.js" format="js">
/**
 *
 * Dashboard
 *
 */

import React from 'react';

import { connect } from 'react-redux';

import actions from '../../actions';
import { ROLES } from '../../constants';
import dashboardLinks from './links.json';
import { isDisabledMerchantAccount } from '../../utils/app';
import Admin from '../../components/Manager/Dashboard/Admin';
import Merchant from '../../components/Manager/Dashboard/Merchant';
import Customer from '../../components/Manager/Dashboard/Customer';
import DisabledMerchantAccount from '../../components/Manager/DisabledAccount/Merchant';
import LoadingIndicator from '../../components/Common/LoadingIndicator';

class Dashboard extends React.PureComponent {
  componentDidMount() {
    this.props.fetchProfile();
  }

  render() {
    const { user, isLoading, isMenuOpen, toggleDashboardMenu } = this.props;

    if (isDisabledMerchantAccount(user))
      return <DisabledMerchantAccount user={user} />;

    return (
      <>
        {isLoading ? (
          <LoadingIndicator inline />
        ) : user.role === ROLES.Admin ? (
          <Admin
            user={user}
            isMenuOpen={isMenuOpen}
            links={dashboardLinks[ROLES.Admin]}
            toggleMenu={toggleDashboardMenu}
          />
        ) : user.role === ROLES.Merchant && user.merchant ? (
          <Merchant
            user={user}
            isMenuOpen={isMenuOpen}
            links={dashboardLinks[ROLES.Merchant]}
            toggleMenu={toggleDashboardMenu}
          />
        ) : (
          <Customer
            user={user}
            isMenuOpen={isMenuOpen}
            links={dashboardLinks[ROLES.Member]}
            toggleMenu={toggleDashboardMenu}
          />
        )}
      </>
    );
  }
}

const mapStateToProps = state => {
  return {
    user: state.account.user,
    isLoading: state.account.isLoading,
    isMenuOpen: state.dashboard.isMenuOpen
  };
};

export default connect(mapStateToProps, actions)(Dashboard);
</file>
<file name="./client/app/containers/Dashboard/actions.js" format="js">
/*
 *
 * Dashboard actions
 *
 */

import { TOGGLE_DASHBOARD_MENU } from './constants';

export const toggleDashboardMenu = () => {
  return {
    type: TOGGLE_DASHBOARD_MENU
  };
};
</file>
<file name="./client/app/containers/Merchant/constants.js" format="js">
/*
 *
 * Merchant constants
 *
 */

export const FETCH_MERCHANTS = 'src/Merchant/FETCH_MERCHANTS';
export const REMOVE_MERCHANT = 'src/Merchant/REMOVE_MERCHANT';
export const SET_ADVANCED_FILTERS = 'src/Merchant/SET_ADVANCED_FILTERS';
export const FETCH_SEARCHED_MERCHANTS = 'src/Merchant/FETCH_SEARCHED_MERCHANTS';
export const MERCHANT_CHANGE = 'src/Merchant/MERCHANT_CHANGE';
export const SET_MERCHANT_FORM_ERRORS = 'src/Merchant/SET_MERCHANT_FORM_ERRORS';
export const SET_MERCHANTS_LOADING = 'src/Merchant/SET_MERCHANTS_LOADING';
export const SET_MERCHANTS_SUBMITTING = 'src/Merchant/SET_MERCHANTS_SUBMITTING';
export const RESET_MERCHANT = 'src/Merchant/RESET_MERCHANT';
export const SIGNUP_CHANGE = 'src/Merchant/SIGNUP_CHANGE';
export const SET_SIGNUP_FORM_ERRORS = 'src/Merchant/SET_SIGNUP_FORM_ERRORS';
export const SIGNUP_RESET = 'src/Merchant/SIGNUP_RESET';
</file>
<file name="./client/app/containers/Merchant/reducer.js" format="js">
/*
 *
 * Merchant reducer
 *
 */

import {
  FETCH_MERCHANTS,
  REMOVE_MERCHANT,
  SET_ADVANCED_FILTERS,
  FETCH_SEARCHED_MERCHANTS,
  MERCHANT_CHANGE,
  SET_MERCHANT_FORM_ERRORS,
  SET_MERCHANTS_LOADING,
  SET_MERCHANTS_SUBMITTING,
  RESET_MERCHANT,
  SIGNUP_CHANGE,
  SET_SIGNUP_FORM_ERRORS,
  SIGNUP_RESET
} from './constants';

const initialState = {
  merchants: [],
  searchedMerchants: [],
  advancedFilters: {
    totalPages: 1,
    currentPage: 1,
    count: 0
  },
  merchantFormData: {
    name: '',
    email: '',
    phoneNumber: '',
    brandName: '',
    business: ''
  },
  formErrors: {},
  signupFormData: {
    email: '',
    firstName: '',
    lastName: '',
    password: ''
  },
  signupFormErrors: {},
  isLoading: false,
  isSubmitting: false
};

const merchantReducer = (state = initialState, action) => {
  switch (action.type) {
    case FETCH_MERCHANTS:
      return {
        ...state,
        merchants: action.payload
      };
    case FETCH_SEARCHED_MERCHANTS:
      return {
        ...state,
        searchedMerchants: action.payload
      };
    case REMOVE_MERCHANT:
      const index = state.merchants.findIndex(b => b._id === action.payload);
      return {
        ...state,
        merchants: [
          ...state.merchants.slice(0, index),
          ...state.merchants.slice(index + 1)
        ]
      };
    case SET_ADVANCED_FILTERS:
      return {
        ...state,
        advancedFilters: {
          ...state.advancedFilters,
          ...action.payload
        }
      };
    case MERCHANT_CHANGE:
      return {
        ...state,
        merchantFormData: {
          ...state.merchantFormData,
          ...action.payload
        }
      };
    case SET_MERCHANT_FORM_ERRORS:
      return {
        ...state,
        formErrors: action.payload
      };
    case SET_MERCHANTS_LOADING:
      return {
        ...state,
        isLoading: action.payload
      };
    case SET_MERCHANTS_SUBMITTING:
      return {
        ...state,
        isSubmitting: action.payload
      };
    case RESET_MERCHANT:
      return {
        ...state,
        merchantFormData: {
          name: '',
          email: '',
          phoneNumber: '',
          brandName: '',
          business: ''
        },
        formErrors: {}
      };
    case SIGNUP_CHANGE:
      return {
        ...state,
        signupFormData: { ...state.signupFormData, ...action.payload }
      };
    case SET_SIGNUP_FORM_ERRORS:
      return {
        ...state,
        signupFormErrors: action.payload
      };
    case SIGNUP_RESET:
      return {
        ...state,
        signupFormData: {
          email: '',
          firstName: '',
          lastName: '',
          password: ''
        }
      };

    default:
      return state;
  }
};

export default merchantReducer;
</file>
<file name="./client/app/containers/Merchant/index.js" format="js">
/*
 *
 * Merchant
 *
 */

import React from 'react';

import { connect } from 'react-redux';
import { Switch, Route } from 'react-router-dom';

import actions from '../../actions';
import { ROLES } from '../../constants';
import List from './List';
import Add from './Add';
import Page404 from '../../components/Common/Page404';

class Merchant extends React.PureComponent {
  render() {
    const { user } = this.props;

    return (
      <div className='merchant-dashboard'>
        <Switch>
          <Route exact path='/dashboard/merchant' component={List} />
          {user.role === ROLES.Admin && (
            <Route exact path='/dashboard/merchant/add' component={Add} />
          )}
          <Route path='*' component={Page404} />
        </Switch>
      </div>
    );
  }
}

const mapStateToProps = state => {
  return {
    user: state.account.user
  };
};

export default connect(mapStateToProps, actions)(Merchant);
</file>
<file name="./client/app/containers/Merchant/Add.js" format="js">
/*
 *
 * Add
 *
 */

import React from 'react';

import { connect } from 'react-redux';

import actions from '../../actions';

import SubPage from '../../components/Manager/SubPage';
import AddMerchant from '../../components/Manager/AddMerchant';

class Add extends React.PureComponent {
  render() {
    const {
      history,
      merchantFormData,
      formErrors,
      isSubmitting,
      merchantChange,
      addMerchant
    } = this.props;

    return (
      <SubPage
        title='Add Merchant'
        actionTitle='Cancel'
        handleAction={() => history.goBack()}
      >
        <AddMerchant
          merchantFormData={merchantFormData}
          formErrors={formErrors}
          isSubmitting={isSubmitting}
          submitTitle='Add Merchant'
          merchantChange={merchantChange}
          addMerchant={() => addMerchant(true)}
        />
      </SubPage>
    );
  }
}

const mapStateToProps = state => {
  return {
    merchantFormData: state.merchant.merchantFormData,
    formErrors: state.merchant.formErrors,
    isSubmitting: state.merchant.isSubmitting,
    isLoading: state.merchant.isLoading
  };
};

export default connect(mapStateToProps, actions)(Add);
</file>
<file name="./client/app/containers/Merchant/actions.js" format="js">
/*
 *
 * Merchant actions
 *
 */

import { push, goBack } from 'connected-react-router';
import { success } from 'react-notification-system-redux';
import axios from 'axios';

import {
  FETCH_MERCHANTS,
  REMOVE_MERCHANT,
  SET_ADVANCED_FILTERS,
  FETCH_SEARCHED_MERCHANTS,
  MERCHANT_CHANGE,
  SET_MERCHANT_FORM_ERRORS,
  SET_MERCHANTS_LOADING,
  SET_MERCHANTS_SUBMITTING,
  RESET_MERCHANT,
  SIGNUP_CHANGE,
  SET_SIGNUP_FORM_ERRORS,
  SIGNUP_RESET
} from './constants';

import handleError from '../../utils/error';
import { allFieldsValidation } from '../../utils/validation';
import { signOut } from '../Login/actions';
import { API_URL } from '../../constants';

export const merchantChange = (name, value) => {
  let formData = {};
  formData[name] = value;

  return {
    type: MERCHANT_CHANGE,
    payload: formData
  };
};

export const merchantSignupChange = (name, value) => {
  let formData = {};
  formData[name] = value;

  return {
    type: SIGNUP_CHANGE,
    payload: formData
  };
};

export const setMerchantLoading = value => {
  return {
    type: SET_MERCHANTS_LOADING,
    payload: value
  };
};

export const setMerchantSubmitting = value => {
  return {
    type: SET_MERCHANTS_SUBMITTING,
    payload: value
  };
};

// add merchant api
export const addMerchant = (isBack = false) => {
  return async (dispatch, getState) => {
    try {
      const phoneno = /^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$/;

      const rules = {
        name: 'required',
        email: 'required|email',
        phoneNumber: ['required', `regex:${phoneno}`],
        brandName: 'required',
        business: 'required|min:10'
      };

      const merchant = getState().merchant.merchantFormData;

      const { isValid, errors } = allFieldsValidation(merchant, rules, {
        'required.name': 'Name is required.',
        'required.email': 'Email is required.',
        'email.email': 'Email format is invalid.',
        'required.phoneNumber': 'Phone number is required.',
        'regex.phoneNumber': 'Phone number format is invalid.',
        'required.brandName': 'Brand is required.',
        'required.business': 'Business is required.',
        'min.business': 'Business must be at least 10 characters.'
      });

      if (!isValid) {
        return dispatch({ type: SET_MERCHANT_FORM_ERRORS, payload: errors });
      }

      dispatch(setMerchantLoading(true));
      dispatch(setMerchantSubmitting(true));

      const response = await axios.post(`${API_URL}/merchant/add`, merchant);

      const successfulOptions = {
        title: `${response.data.message}`,
        position: 'tr',
        autoDismiss: 1
      };

      if (response.data.success === true) {
        dispatch(success(successfulOptions));
        dispatch({ type: RESET_MERCHANT });
        if (isBack) dispatch(goBack());
      }
    } catch (error) {
      handleError(error, dispatch);
    } finally {
      dispatch(setMerchantSubmitting(false));
      dispatch(setMerchantLoading(false));
    }
  };
};

export const fetchMerchants = (n, v) => {
  return async (dispatch, getState) => {
    try {
      dispatch(setMerchantLoading(true));

      const response = await axios.get(`${API_URL}/merchant`, {
        params: {
          page: v ?? 1,
          limit: 20
        }
      });

      const { merchants, totalPages, currentPage, count } = response.data;

      dispatch({
        type: FETCH_MERCHANTS,
        payload: merchants
      });

      dispatch({
        type: SET_ADVANCED_FILTERS,
        payload: { totalPages, currentPage, count }
      });
    } catch (error) {
      handleError(error, dispatch);
    } finally {
      dispatch(setMerchantLoading(false));
    }
  };
};

export const searchMerchants = filter => {
  return async (dispatch, getState) => {
    try {
      dispatch(setMerchantLoading(true));

      const response = await axios.get(`${API_URL}/merchant/search`, {
        params: {
          search: filter.value
        }
      });

      dispatch({
        type: FETCH_SEARCHED_MERCHANTS,
        payload: response.data.merchants
      });
    } catch (error) {
      handleError(error, dispatch);
    } finally {
      dispatch(setMerchantLoading(false));
    }
  };
};

export const disableMerchant = (merchant, value, search, page) => {
  return async (dispatch, getState) => {
    try {
      await axios.put(`${API_URL}/merchant/${merchant._id}/active`, {
        merchant: {
          isActive: value
        }
      });

      if (search)
        return dispatch(searchMerchants({ name: 'merchant', value: search })); // update search list if this is a search result
      dispatch(fetchMerchants('merchant', page));
    } catch (error) {
      handleError(error, dispatch);
    }
  };
};

export const approveMerchant = (merchant, search, page) => {
  return async (dispatch, getState) => {
    try {
      await axios.put(`${API_URL}/merchant/approve/${merchant._id}`);

      if (search)
        return dispatch(searchMerchants({ name: 'merchant', value: search })); // update search list if this is a search result
      dispatch(fetchMerchants('merchant', page));
    } catch (error) {
      handleError(error, dispatch);
    }
  };
};

export const rejectMerchant = (merchant, search, page) => {
  return async (dispatch, getState) => {
    try {
      await axios.put(`${API_URL}/merchant/reject/${merchant._id}`);

      if (search)
        return dispatch(searchMerchants({ name: 'merchant', value: search })); // update search list if this is a search result
      dispatch(fetchMerchants('merchant', page));
    } catch (error) {
      handleError(error, dispatch);
    }
  };
};

export const merchantSignUp = token => {
  return async (dispatch, getState) => {
    try {
      const rules = {
        email: 'required|email',
        password: 'required|min:6',
        firstName: 'required',
        lastName: 'required'
      };

      const merchant = getState().merchant.signupFormData;

      const { isValid, errors } = allFieldsValidation(merchant, rules, {
        'required.email': 'Email is required.',
        'required.password': 'Password is required.',
        'required.firstName': 'First Name is required.',
        'required.lastName': 'Last Name is required.'
      });

      if (!isValid) {
        return dispatch({ type: SET_SIGNUP_FORM_ERRORS, payload: errors });
      }

      await axios.post(`${API_URL}/merchant/signup/${token}`, merchant);

      const successfulOptions = {
        title: `You have signed up successfully! Please sign in with the email and password. Thank you!`,
        position: 'tr',
        autoDismiss: 1
      };

      dispatch(signOut());
      dispatch(success(successfulOptions));
      dispatch(push('/login'));
      dispatch({ type: SIGNUP_RESET });
    } catch (error) {
      const title = `Please try to signup again!`;
      handleError(error, dispatch, title);
    }
  };
};

// delete merchant api
export const deleteMerchant = (merchant, search, page) => {
  return async (dispatch, getState) => {
    try {
      const response = await axios.delete(
        `${API_URL}/merchant/delete/${merchant._id}`
      );

      const successfulOptions = {
        title: `${response.data.message}`,
        position: 'tr',
        autoDismiss: 1
      };

      if (response.data.success === true) {
        dispatch(success(successfulOptions));

        if (search)
          return dispatch(searchMerchants({ name: 'merchant', value: search })); // update search list if this is a search result

        dispatch(fetchMerchants('merchant', page));

        // dispatch({
        //   type: REMOVE_MERCHANT,
        //   payload: merchant._id
        // });
      }
    } catch (error) {
      handleError(error, dispatch);
    }
  };
};
</file>
<file name="./client/app/containers/Merchant/List.js" format="js">
/*
 *
 * List
 *
 */

import React from 'react';

import { connect } from 'react-redux';

import actions from '../../actions';
import { ROLES } from '../../constants';

import SubPage from '../../components/Manager/SubPage';
import MerchantList from '../../components/Manager/MerchantList';
import MerchantSearch from '../../components/Manager/MerchantSearch';
import SearchResultMeta from '../../components/Manager/SearchResultMeta';
import LoadingIndicator from '../../components/Common/LoadingIndicator';
import NotFound from '../../components/Common/NotFound';
import Pagination from '../../components/Common/Pagination';

class List extends React.PureComponent {
  constructor(props) {
    super(props);

    this.state = {
      search: ''
    };
  }

  componentDidMount() {
    this.props.fetchMerchants();
  }

  handleMerchantSearch = e => {
    if (e.value.length >= 2) {
      this.props.searchMerchants({ name: 'merchant', value: e.value });
      this.setState({
        search: e.value
      });
    } else {
      this.setState({
        search: ''
      });
    }
  };

  handleOnPagination = (n, v) => {
    this.props.fetchUsers(v);
  };

  render() {
    const {
      history,
      user,
      merchants,
      isLoading,
      searchedMerchants,
      advancedFilters,
      fetchMerchants,
      approveMerchant,
      rejectMerchant,
      deleteMerchant,
      disableMerchant,
      searchMerchants
    } = this.props;

    const { search } = this.state;
    const isSearch = search.length > 0;
    const filteredMerchants = search ? searchedMerchants : merchants;
    const displayPagination = advancedFilters.totalPages > 1;
    const displayMerchants = filteredMerchants && filteredMerchants.length > 0;

    return (
      <div className='merchant-dashboard'>
        <SubPage
          title={'Merchants'}
          actionTitle={user.role === ROLES.Admin && 'Add'}
          handleAction={() => history.push('/dashboard/merchant/add')}
        />
        <MerchantSearch
          onSearch={this.handleMerchantSearch}
          onSearchSubmit={searchMerchants}
        />
        {isLoading && <LoadingIndicator />}
        {displayMerchants && (
          <>
            {!isSearch && displayPagination && (
              <Pagination
                totalPages={advancedFilters.totalPages}
                onPagination={fetchMerchants}
              />
            )}
            <SearchResultMeta
              label='merchants'
              count={
                isSearch ? filteredMerchants.length : advancedFilters.count
              }
            />
            <MerchantList
              merchants={filteredMerchants}
              approveMerchant={m =>
                approveMerchant(m, search, advancedFilters.currentPage)
              }
              rejectMerchant={m =>
                rejectMerchant(m, search, advancedFilters.currentPage)
              }
              deleteMerchant={m =>
                deleteMerchant(m, search, advancedFilters.currentPage)
              }
              disableMerchant={(m, v) =>
                disableMerchant(m, v, search, advancedFilters.currentPage)
              }
            />
          </>
        )}
        {!isLoading && !displayMerchants && (
          <NotFound message='No merchants found.' />
        )}
      </div>
    );
  }
}

const mapStateToProps = state => {
  return {
    merchants: state.merchant.merchants,
    advancedFilters: state.merchant.advancedFilters,
    isLoading: state.merchant.isLoading,
    searchedMerchants: state.merchant.searchedMerchants,
    user: state.account.user
  };
};

export default connect(mapStateToProps, actions)(List);
</file>
<file name="./client/app/containers/Review/constants.js" format="js">
/*
 *
 * Review constants
 *
 */

export const FETCH_REVIEWS = 'src/Review/FETCH_REVIEWS';
export const ADD_REVIEW = 'src/Review/ADD_REVIEW';
export const REMOVE_REVIEW = 'src/Review/REMOVE_REVIEW';
export const FETCH_PRODUCT_REVIEWS = 'src/Review/FETCH_PRODUCT_REVIEWS';
export const REVIEW_CHANGE = 'src/Review/REVIEW_CHANGE';
export const SET_REVIEWS_LOADING = 'src/Review/SET_REVIEWS_LOADING';
export const RESET_REVIEW = 'src/Review/RESET_REVIEW';
export const SET_REVIEW_FORM_ERRORS = 'src/Review/SET_REVIEW_FORM_ERRORS';
export const SET_ADVANCED_FILTERS = 'src/Review/SET_ADVANCED_FILTERS';
</file>
<file name="./client/app/containers/Review/reducer.js" format="js">
/*
 *
 * Review reducer
 *
 */

import {
  FETCH_REVIEWS,
  ADD_REVIEW,
  REMOVE_REVIEW,
  FETCH_PRODUCT_REVIEWS,
  REVIEW_CHANGE,
  SET_REVIEWS_LOADING,
  RESET_REVIEW,
  SET_REVIEW_FORM_ERRORS,
  SET_ADVANCED_FILTERS
} from './constants';

const initialState = {
  reviews: [],
  isLoading: false,
  advancedFilters: {
    totalPages: 1,
    currentPage: 1,
    count: 0
  },
  productReviews: [],
  reviewsSummary: {
    ratingSummary: [],
    totalRatings: 0,
    totalReviews: 0,
    totalSummary: 0
  },
  reviewFormData: {
    title: '',
    review: '',
    rating: 0,
    isRecommended: {
      value: 1,
      label: 'Yes'
    }
  },
  reviewFormErrors: {}
};

const reviewReducer = (state = initialState, action) => {
  switch (action.type) {
    case FETCH_REVIEWS:
      return {
        ...state,
        reviews: action.payload
      };
    case SET_ADVANCED_FILTERS:
      return {
        ...state,
        advancedFilters: {
          ...state.advancedFilters,
          ...action.payload
        }
      };
    case FETCH_PRODUCT_REVIEWS:
      return {
        ...state,
        productReviews: action.payload.reviews,
        reviewsSummary: action.payload.reviewsSummary
      };
    case ADD_REVIEW:
      return {
        ...state,
        productReviews: [...state.productReviews, action.payload]
      };
    case REMOVE_REVIEW:
      const index = state.reviews.findIndex(r => r._id === action.payload);
      return {
        ...state,
        reviews: [
          ...state.reviews.slice(0, index),
          ...state.reviews.slice(index + 1)
        ]
      };
    case REVIEW_CHANGE:
      return {
        ...state,
        reviewFormData: {
          ...state.reviewFormData,
          ...action.payload
        }
      };
    case SET_REVIEWS_LOADING:
      return {
        ...state,
        isLoading: action.payload
      };
    case RESET_REVIEW:
      return {
        ...state,
        reviewFormData: {
          title: '',
          review: '',
          rating: 0,
          isRecommended: {
            value: 1,
            label: 'Yes'
          }
        },
        reviewFormErrors: {}
      };
    case SET_REVIEW_FORM_ERRORS:
      return {
        ...state,
        reviewFormErrors: action.payload
      };

    default:
      return state;
  }
};

export default reviewReducer;
</file>
<file name="./client/app/containers/Review/index.js" format="js">
/*
 *
 * Review
 *
 */

import React from 'react';
import { connect } from 'react-redux';

import actions from '../../actions';

import SubPage from '../../components/Manager/SubPage';
import ReviewList from '../../components/Manager/ReviewList';
import SearchResultMeta from '../../components/Manager/SearchResultMeta';
import LoadingIndicator from '../../components/Common/LoadingIndicator';
import NotFound from '../../components/Common/NotFound';
import Pagination from '../../components/Common/Pagination';

class Review extends React.PureComponent {
  componentDidMount() {
    this.props.fetchReviews();
  }

  render() {
    const {
      reviews,
      isLoading,
      advancedFilters,
      fetchReviews,
      approveReview,
      rejectReview,
      deleteReview
    } = this.props;

    const displayPagination = advancedFilters.totalPages > 1;
    const displayReviews = reviews && reviews.length > 0;

    return (
      <div className='review-dashboard'>
        <SubPage title={'Reviews'} isMenuOpen={null}>
          {isLoading && <LoadingIndicator />}

          {displayPagination && (
            <Pagination
              totalPages={advancedFilters.totalPages}
              onPagination={fetchReviews}
            />
          )}
          {displayReviews && (
            <>
              <SearchResultMeta label='reviews' count={advancedFilters.count} />
              <ReviewList
                reviews={reviews}
                approveReview={approveReview}
                rejectReview={rejectReview}
                deleteReview={deleteReview}
              />
            </>
          )}

          {!isLoading && !displayReviews && (
            <NotFound message='No reviews found.' />
          )}
        </SubPage>
      </div>
    );
  }
}

const mapStateToProps = state => {
  return {
    reviews: state.review.reviews,
    isLoading: state.review.isLoading,
    advancedFilters: state.review.advancedFilters
  };
};

export default connect(mapStateToProps, actions)(Review);
</file>
<file name="./client/app/containers/Review/actions.js" format="js">
/*
 *
 * Review actions
 *
 */

import { success } from 'react-notification-system-redux';
import axios from 'axios';
import DOMPurify from 'dompurify';

import {
  FETCH_REVIEWS,
  SET_REVIEWS_LOADING,
  ADD_REVIEW,
  REMOVE_REVIEW,
  FETCH_PRODUCT_REVIEWS,
  REVIEW_CHANGE,
  RESET_REVIEW,
  SET_REVIEW_FORM_ERRORS,
  SET_ADVANCED_FILTERS
} from './constants';
import handleError from '../../utils/error';
import { allFieldsValidation, santizeFields } from '../../utils/validation';
import { API_URL } from '../../constants';

export const reviewChange = (name, value) => {
  let formData = {};
  formData[name] = value;
  return {
    type: REVIEW_CHANGE,
    payload: formData
  };
};

// fetch reviews api
export const fetchReviews = (n, v) => {
  return async (dispatch, getState) => {
    try {
      dispatch({ type: SET_REVIEWS_LOADING, payload: true });

      const response = await axios.get(`${API_URL}/review`, {
        params: {
          page: v ?? 1,
          limit: 20
        }
      });

      const { reviews, totalPages, currentPage, count } = response.data;

      dispatch({ type: FETCH_REVIEWS, payload: reviews });
      dispatch({
        type: SET_ADVANCED_FILTERS,
        payload: { totalPages, currentPage, count }
      });
    } catch (error) {
      handleError(error, dispatch);
    } finally {
      dispatch({ type: SET_REVIEWS_LOADING, payload: false });
    }
  };
};

export const approveReview = review => {
  return async (dispatch, getState) => {
    try {
      await axios.put(`${API_URL}/review/approve/${review._id}`);

      dispatch(fetchReviews());
    } catch (error) {
      handleError(error, dispatch);
    }
  };
};

export const rejectReview = review => {
  return async (dispatch, getState) => {
    try {
      await axios.put(`${API_URL}/review/reject/${review._id}`);

      dispatch(fetchReviews());
    } catch (error) {
      handleError(error, dispatch);
    }
  };
};

// delete review api
export const deleteReview = id => {
  return async (dispatch, getState) => {
    try {
      const response = await axios.delete(`${API_URL}/review/delete/${id}`);

      const successfulOptions = {
        title: `${response.data.message}`,
        position: 'tr',
        autoDismiss: 1
      };

      if (response.data.success == true) {
        dispatch(success(successfulOptions));
        dispatch({
          type: REMOVE_REVIEW,
          payload: id
        });
      }
    } catch (error) {
      handleError(error, dispatch);
    }
  };
};

// fetch product reviews api
export const fetchProductReviews = slug => {
  return async (dispatch, getState) => {
    try {
      const response = await axios.get(`${API_URL}/review/${slug}`);

      const { ratingSummary, totalRatings, totalReviews, totalSummary } =
        getProductReviewsSummary(response.data.reviews);

      dispatch({
        type: FETCH_PRODUCT_REVIEWS,
        payload: {
          reviews: response.data.reviews,
          reviewsSummary: {
            ratingSummary,
            totalRatings,
            totalReviews,
            totalSummary
          }
        }
      });
    } catch (error) {
      handleError(error, dispatch);
    }
  };
};

export const addProductReview = () => {
  return async (dispatch, getState) => {
    try {
      const rules = {
        title: 'required',
        review: 'required',
        rating: 'required|numeric|min:1',
        isRecommended: 'required'
      };

      const review = getState().review.reviewFormData;
      const product = getState().product.storeProduct;

      const newReview = {
        product: product._id,
        isRecommended: review.isRecommended.value,
        rating: review.rating,
        review: review.review,
        title: review.title
      };

      const { isValid, errors } = allFieldsValidation(newReview, rules, {
        'required.title': 'Title is required.',
        'required.review': 'Review is required.',
        'required.rating': 'Rating is required.',
        'min.rating': 'Rating is required.',
        'required.isRecommended': 'Recommendable is required.'
      });

      if (!isValid) {
        return dispatch({ type: SET_REVIEW_FORM_ERRORS, payload: errors });
      }

      const santizedReview = santizeFields(newReview);
      const response = await axios.post(
        `${API_URL}/review/add`,
        santizedReview
      );

      const successfulOptions = {
        title: `${response.data.message}`,
        position: 'tr',
        autoDismiss: 1
      };

      if (response.data.success === true) {
        dispatch(success(successfulOptions));
        dispatch(fetchProductReviews(product.slug));

        // dispatch({
        //   type: ADD_REVIEW,
        //   payload: response.data.review
        // });
        dispatch({ type: RESET_REVIEW });
      }
    } catch (error) {
      handleError(error, dispatch);
    }
  };
};

export const getProductReviewsSummary = reviews => {
  let ratingSummary = [{ 5: 0 }, { 4: 0 }, { 3: 0 }, { 2: 0 }, { 1: 0 }];
  let totalRatings = 0;
  let totalReviews = 0;
  let totalSummary = 0;

  if (reviews.length > 0) {
    reviews.map((item, i) => {
      totalRatings += item.rating;
      totalReviews += 1;

      switch (Math.round(item.rating)) {
        case 5:
          ratingSummary[0][5] += 1;
          totalSummary += 1;
          break;
        case 4:
          ratingSummary[1][4] += 1;
          totalSummary += 1;

          break;
        case 3:
          ratingSummary[2][3] += 1;
          totalSummary += 1;

          break;
        case 2:
          ratingSummary[3][2] += 1;
          totalSummary += 1;

          break;
        case 1:
          ratingSummary[4][1] += 1;
          totalSummary += 1;

          break;
        default:
          0;
          break;
      }
    });
  }

  return { ratingSummary, totalRatings, totalReviews, totalSummary };
};
</file>
<file name="./client/app/containers/CategoryShop/index.js" format="js">
/**
 *
 * CategoryShop
 *
 */

import React from 'react';
import { connect } from 'react-redux';

import actions from '../../actions';

import ProductList from '../../components/Store/ProductList';
import NotFound from '../../components/Common/NotFound';
import LoadingIndicator from '../../components/Common/LoadingIndicator';

class CategoryShop extends React.PureComponent {
  componentDidMount() {
    const slug = this.props.match.params.slug;
    this.props.filterProducts('category', slug);
  }

  componentDidUpdate(prevProps) {
    if (this.props.match.params.slug !== prevProps.match.params.slug) {
      const slug = this.props.match.params.slug;
      this.props.filterProducts('category', slug);
    }
  }

  render() {
    const { products, isLoading, authenticated, updateWishlist } = this.props;

    return (
      <div className='category-shop'>
        {isLoading && <LoadingIndicator />}
        {products && products.length > 0 && (
          <ProductList
            products={products}
            authenticated={authenticated}
            updateWishlist={updateWishlist}
          />
        )}
        {!isLoading && products && products.length <= 0 && (
          <NotFound message='No products found.' />
        )}
      </div>
    );
  }
}

const mapStateToProps = state => {
  return {
    products: state.product.storeProducts,
    isLoading: state.product.isLoading,
    authenticated: state.authentication.authenticated
  };
};

export default connect(mapStateToProps, actions)(CategoryShop);
</file>
<file name="./client/app/containers/Newsletter/constants.js" format="js">
/*
 *
 * Newsletter constants
 *
 */

export const NEWSLETTER_CHANGE = 'src/Newsletter/NEWSLETTER_CHANGE';
export const SET_NEWSLETTER_FORM_ERRORS =
  'src/Newsletter/SET_NEWSLETTER_FORM_ERRORS';
export const NEWSLETTER_RESET = 'src/Newsletter/NEWSLETTER_RESET';
</file>
<file name="./client/app/containers/Newsletter/reducer.js" format="js">
/*
 *
 * Newsletter reducer
 *
 */

import {
  NEWSLETTER_CHANGE,
  SET_NEWSLETTER_FORM_ERRORS,
  NEWSLETTER_RESET
} from './constants';

const initialState = {
  email: '',
  formErrors: {}
};

const newsletterReducer = (state = initialState, action) => {
  switch (action.type) {
    case NEWSLETTER_CHANGE:
      return {
        ...state,
        email: action.payload
      };
    case SET_NEWSLETTER_FORM_ERRORS:
      return {
        ...state,
        formErrors: action.payload
      };
    case NEWSLETTER_RESET:
      return {
        ...state,
        email: '',
        formErrors: {}
      };
    default:
      return state;
  }
};

export default newsletterReducer;
</file>
<file name="./client/app/containers/Newsletter/index.js" format="js">
/*
 *
 * Newsletter
 *
 */

import React from 'react';

import { connect } from 'react-redux';

import actions from '../../actions';

import Input from '../../components/Common/Input';
import Button from '../../components/Common/Button';

class Newsletter extends React.PureComponent {
  render() {
    const { email, newsletterChange, subscribeToNewsletter, formErrors } =
      this.props;

    const handleSubmit = event => {
      event.preventDefault();
      subscribeToNewsletter();
    };

    return (
      <div className='newsletter-form'>
        <p>Sign Up for Our Newsletter</p>
        <form onSubmit={handleSubmit}>
          <div className='subscribe'>
            <Input
              type={'text'}
              error={formErrors['email']}
              name={'email'}
              placeholder={'Please Enter Your Email'}
              value={email}
              onInputChange={(name, value) => {
                newsletterChange(name, value);
              }}
              inlineElement={SubscribeButton}
            />
          </div>
        </form>
      </div>
    );
  }
}

const SubscribeButton = (
  <Button type='submit' variant='primary' text='Subscribe' />
);

const mapStateToProps = state => {
  return {
    email: state.newsletter.email,
    formErrors: state.newsletter.formErrors
  };
};

export default connect(mapStateToProps, actions)(Newsletter);
</file>
<file name="./client/app/containers/Newsletter/actions.js" format="js">
/*
 *
 * Newsletter actions
 *
 */

import { success } from 'react-notification-system-redux';
import axios from 'axios';

import {
  NEWSLETTER_CHANGE,
  SET_NEWSLETTER_FORM_ERRORS,
  NEWSLETTER_RESET
} from './constants';
import handleError from '../../utils/error';
import { allFieldsValidation } from '../../utils/validation';
import { API_URL } from '../../constants';

export const newsletterChange = (name, value) => {
  return {
    type: NEWSLETTER_CHANGE,
    payload: value
  };
};

export const subscribeToNewsletter = () => {
  return async (dispatch, getState) => {
    try {
      const rules = {
        email: 'required|email'
      };

      const user = {};
      user.email = getState().newsletter.email;

      const { isValid, errors } = allFieldsValidation(user, rules, {
        'required.email': 'Email is required.',
        'email.email': 'Email format is invalid.'
      });

      if (!isValid) {
        return dispatch({ type: SET_NEWSLETTER_FORM_ERRORS, payload: errors });
      }

      const response = await axios.post(
        `${API_URL}/newsletter/subscribe`,
        user
      );

      const successfulOptions = {
        title: `${response.data.message}`,
        position: 'tr',
        autoDismiss: 1
      };

      dispatch({ type: NEWSLETTER_RESET });
      dispatch(success(successfulOptions));
    } catch (error) {
      handleError(error, dispatch);
    }
  };
};
</file>
<file name="./client/app/containers/ProductsShop/index.js" format="js">
/**
 *
 * ProductsShop
 *
 */

import React from 'react';

import { connect } from 'react-redux';

import actions from '../../actions';

import ProductList from '../../components/Store/ProductList';
import NotFound from '../../components/Common/NotFound';
import LoadingIndicator from '../../components/Common/LoadingIndicator';

class ProductsShop extends React.PureComponent {
  componentDidMount() {
    const slug = this.props.match.params.slug;
    this.props.filterProducts(slug);
  }

  render() {
    const { products, isLoading, authenticated, updateWishlist } = this.props;

    const displayProducts = products && products.length > 0;

    return (
      <div className='products-shop'>
        {isLoading && <LoadingIndicator />}
        {displayProducts && (
          <ProductList
            products={products}
            authenticated={authenticated}
            updateWishlist={updateWishlist}
          />
        )}
        {!isLoading && !displayProducts && (
          <NotFound message='No products found.' />
        )}
      </div>
    );
  }
}

const mapStateToProps = state => {
  return {
    products: state.product.storeProducts,
    isLoading: state.product.isLoading,
    authenticated: state.authentication.authenticated
  };
};

export default connect(mapStateToProps, actions)(ProductsShop);
</file>
<file name="./client/app/containers/Brand/constants.js" format="js">
/*
 *
 * Brand constants
 *
 */

export const FETCH_BRANDS = 'src/Brand/FETCH_BRANDS';
export const FETCH_STORE_BRANDS = 'src/Brand/FETCH_STORE_BRANDS';
export const FETCH_BRAND = 'src/Brand/FETCH_BRAND';
export const BRAND_CHANGE = 'src/Brand/BRAND_CHANGE';
export const BRAND_EDIT_CHANGE = 'src/Brand/BRAND_EDIT_CHANGE';
export const SET_BRAND_FORM_ERRORS = 'src/Brand/SET_BRAND_FORM_ERRORS';
export const SET_BRAND_FORM_EDIT_ERRORS =
  'src/Brand/SET_BRAND_FORM_EDIT_ERRORS';
export const RESET_BRAND = 'src/Brand/RESET_BRAND';
export const ADD_BRAND = 'src/Brand/ADD_BRAND';
export const REMOVE_BRAND = 'src/Brand/REMOVE_BRAND';
export const FETCH_BRANDS_SELECT = 'src/Brand/FETCH_BRANDS_SELECT';
export const SET_BRANDS_LOADING = 'src/Brand/SET_BRANDS_LOADING';
</file>
<file name="./client/app/containers/Brand/reducer.js" format="js">
/*
 *
 * Brand reducer
 *
 */

import {
  FETCH_BRANDS,
  FETCH_STORE_BRANDS,
  FETCH_BRAND,
  BRAND_CHANGE,
  BRAND_EDIT_CHANGE,
  SET_BRAND_FORM_ERRORS,
  SET_BRAND_FORM_EDIT_ERRORS,
  ADD_BRAND,
  REMOVE_BRAND,
  FETCH_BRANDS_SELECT,
  RESET_BRAND,
  SET_BRANDS_LOADING
} from './constants';

const initialState = {
  brands: [],
  storeBrands: [],
  brand: {
    name: '',
    description: ''
  },
  brandsSelect: [],
  brandFormData: {
    name: '',
    description: '',
    isActive: true
  },
  formErrors: {},
  editFormErrors: {},
  isLoading: false
};

const brandReducer = (state = initialState, action) => {
  switch (action.type) {
    case FETCH_BRANDS:
      return {
        ...state,
        brands: action.payload
      };
    case FETCH_STORE_BRANDS:
      return {
        ...state,
        storeBrands: action.payload
      };
    case FETCH_BRAND:
      return {
        ...state,
        brand: action.payload,
        editFormErrors: {}
      };
    case FETCH_BRANDS_SELECT:
      return {
        ...state,
        brandsSelect: action.payload
      };
    case ADD_BRAND:
      return {
        ...state,
        brands: [...state.brands, action.payload]
      };
    case REMOVE_BRAND:
      const index = state.brands.findIndex(b => b._id === action.payload);
      return {
        ...state,
        brands: [
          ...state.brands.slice(0, index),
          ...state.brands.slice(index + 1)
        ]
      };
    case BRAND_CHANGE:
      return {
        ...state,
        brandFormData: {
          ...state.brandFormData,
          ...action.payload
        }
      };
    case BRAND_EDIT_CHANGE:
      return {
        ...state,
        brand: {
          ...state.brand,
          ...action.payload
        }
      };
    case SET_BRAND_FORM_ERRORS:
      return {
        ...state,
        formErrors: action.payload
      };
    case SET_BRAND_FORM_EDIT_ERRORS:
      return {
        ...state,
        editFormErrors: action.payload
      };
    case SET_BRANDS_LOADING:
      return {
        ...state,
        isLoading: action.payload
      };
    case RESET_BRAND:
      return {
        ...state,
        brandFormData: {
          name: '',
          description: '',
          isActive: true
        },
        formErrors: {}
      };
    default:
      return state;
  }
};

export default brandReducer;
</file>
<file name="./client/app/containers/Brand/Edit.js" format="js">
/*
 *
 * Edit
 *
 */

import React from 'react';

import { connect } from 'react-redux';

import actions from '../../actions';

import EditBrand from '../../components/Manager/EditBrand';
import SubPage from '../../components/Manager/SubPage';
import NotFound from '../../components/Common/NotFound';

class Edit extends React.PureComponent {
  componentDidMount() {
    const brandId = this.props.match.params.id;
    this.props.fetchBrand(brandId);
  }

  componentDidUpdate(prevProps) {
    if (this.props.match.params.id !== prevProps.match.params.id) {
      const brandId = this.props.match.params.id;
      this.props.fetchBrand(brandId);
    }
  }

  render() {
    const {
      history,
      user,
      brand,
      formErrors,
      brandEditChange,
      updateBrand,
      deleteBrand,
      activateBrand
    } = this.props;

    return (
      <SubPage
        title='Edit Brand'
        actionTitle='Cancel'
        handleAction={history.goBack}
      >
        {brand?._id ? (
          <EditBrand
            user={user}
            brand={brand}
            brandChange={brandEditChange}
            formErrors={formErrors}
            updateBrand={updateBrand}
            deleteBrand={deleteBrand}
            activateBrand={activateBrand}
          />
        ) : (
          <NotFound message='No brand found.' />
        )}
      </SubPage>
    );
  }
}

const mapStateToProps = state => {
  return {
    user: state.account.user,
    brand: state.brand.brand,
    formErrors: state.brand.editFormErrors
  };
};

export default connect(mapStateToProps, actions)(Edit);
</file>
<file name="./client/app/containers/Brand/index.js" format="js">
/*
 *
 * Brand
 *
 */

import React from 'react';

import { connect } from 'react-redux';
import { Switch, Route } from 'react-router-dom';

import actions from '../../actions';
import { ROLES } from '../../constants';
import List from './List';
import Add from './Add';
import Edit from './Edit';
import Page404 from '../../components/Common/Page404';

class Brand extends React.PureComponent {
  render() {
    const { user } = this.props;

    return (
      <div className='brand-dashboard'>
        <Switch>
          <Route exact path='/dashboard/brand' component={List} />
          <Route exact path='/dashboard/brand/edit/:id' component={Edit} />
          {user.role === ROLES.Admin && (
            <Route exact path='/dashboard/brand/add' component={Add} />
          )}
          <Route path='*' component={Page404} />
        </Switch>
      </div>
    );
  }
}

const mapStateToProps = state => {
  return {
    user: state.account.user
  };
};

export default connect(mapStateToProps, actions)(Brand);
</file>
<file name="./client/app/containers/Brand/Add.js" format="js">
/*
 *
 * Add
 *
 */

import React from 'react';

import { connect } from 'react-redux';

import actions from '../../actions';

import AddBrand from '../../components/Manager/AddBrand';
import SubPage from '../../components/Manager/SubPage';

class Add extends React.PureComponent {
  render() {
    const {
      history,
      brandFormData,
      formErrors,
      brandChange,
      addBrand
    } = this.props;

    return (
      <SubPage
        title='Add Brand'
        actionTitle='Cancel'
        handleAction={() => history.goBack()}
      >
        <AddBrand
          brandFormData={brandFormData}
          formErrors={formErrors}
          brandChange={brandChange}
          addBrand={addBrand}
        />
      </SubPage>
    );
  }
}

const mapStateToProps = state => {
  return {
    brandFormData: state.brand.brandFormData,
    formErrors: state.brand.formErrors
  };
};

export default connect(mapStateToProps, actions)(Add);
</file>
<file name="./client/app/containers/Brand/actions.js" format="js">
/*
 *
 * Brand actions
 *
 */

import { goBack } from 'connected-react-router';
import { success } from 'react-notification-system-redux';
import axios from 'axios';

import {
  FETCH_BRANDS,
  FETCH_STORE_BRANDS,
  FETCH_BRAND,
  BRAND_CHANGE,
  BRAND_EDIT_CHANGE,
  SET_BRAND_FORM_ERRORS,
  SET_BRAND_FORM_EDIT_ERRORS,
  ADD_BRAND,
  REMOVE_BRAND,
  FETCH_BRANDS_SELECT,
  SET_BRANDS_LOADING,
  RESET_BRAND
} from './constants';

import handleError from '../../utils/error';
import { formatSelectOptions } from '../../utils/select';
import { allFieldsValidation } from '../../utils/validation';
import { API_URL } from '../../constants';

export const brandChange = (name, value) => {
  let formData = {};
  formData[name] = value;

  return {
    type: BRAND_CHANGE,
    payload: formData
  };
};

export const brandEditChange = (name, value) => {
  let formData = {};
  formData[name] = value;

  return {
    type: BRAND_EDIT_CHANGE,
    payload: formData
  };
};

// fetch store brands api
export const fetchStoreBrands = () => {
  return async (dispatch, getState) => {
    try {
      const response = await axios.get(`${API_URL}/brand/list`);

      dispatch({
        type: FETCH_STORE_BRANDS,
        payload: response.data.brands
      });
    } catch (error) {
      handleError(error, dispatch);
    }
  };
};

// fetch brands api
export const fetchBrands = () => {
  return async (dispatch, getState) => {
    try {
      dispatch({ type: SET_BRANDS_LOADING, payload: true });

      const response = await axios.get(`${API_URL}/brand`);

      dispatch({
        type: FETCH_BRANDS,
        payload: response.data.brands
      });
    } catch (error) {
      handleError(error, dispatch);
    } finally {
      dispatch({ type: SET_BRANDS_LOADING, payload: false });
    }
  };
};

// fetch brand api
export const fetchBrand = brandId => {
  return async (dispatch, getState) => {
    try {
      const response = await axios.get(`${API_URL}/brand/${brandId}`);

      dispatch({
        type: FETCH_BRAND,
        payload: response.data.brand
      });
    } catch (error) {
      handleError(error, dispatch);
    }
  };
};

// fetch brands select api
export const fetchBrandsSelect = () => {
  return async (dispatch, getState) => {
    try {
      const response = await axios.get(`${API_URL}/brand/list/select`);

      const formattedBrands = formatSelectOptions(response.data.brands, true);

      dispatch({
        type: FETCH_BRANDS_SELECT,
        payload: formattedBrands
      });
    } catch (error) {
      handleError(error, dispatch);
    }
  };
};

// add brand api
export const addBrand = () => {
  return async (dispatch, getState) => {
    try {
      const rules = {
        name: 'required',
        description: 'required|max:200'
      };

      const brand = getState().brand.brandFormData;

      const { isValid, errors } = allFieldsValidation(brand, rules, {
        'required.name': 'Name is required.',
        'required.description': 'Description is required.',
        'max.description': 'Description may not be greater than 200 characters.'
      });

      if (!isValid) {
        return dispatch({ type: SET_BRAND_FORM_ERRORS, payload: errors });
      }

      const response = await axios.post(`${API_URL}/brand/add`, brand);

      const successfulOptions = {
        title: `${response.data.message}`,
        position: 'tr',
        autoDismiss: 1
      };

      if (response.data.success === true) {
        dispatch(success(successfulOptions));
        dispatch({
          type: ADD_BRAND,
          payload: response.data.brand
        });

        dispatch(goBack());
        dispatch({ type: RESET_BRAND });
      }
    } catch (error) {
      handleError(error, dispatch);
    }
  };
};

// update brand api
export const updateBrand = () => {
  return async (dispatch, getState) => {
    try {
      const rules = {
        name: 'required',
        slug: 'required|alpha_dash',
        description: 'required|max:200'
      };

      const brand = getState().brand.brand;

      const newBrand = {
        name: brand.name,
        slug: brand.slug,
        description: brand.description
      };

      const { isValid, errors } = allFieldsValidation(newBrand, rules, {
        'required.name': 'Name is required.',
        'required.slug': 'Slug is required.',
        'alpha_dash.slug':
          'Slug may have alpha-numeric characters, as well as dashes and underscores only.',
        'required.description': 'Description is required.',
        'max.description': 'Description may not be greater than 200 characters.'
      });

      if (!isValid) {
        return dispatch({ type: SET_BRAND_FORM_EDIT_ERRORS, payload: errors });
      }

      const response = await axios.put(`${API_URL}/brand/${brand._id}`, {
        brand: newBrand
      });

      const successfulOptions = {
        title: `${response.data.message}`,
        position: 'tr',
        autoDismiss: 1
      };

      if (response.data.success === true) {
        dispatch(success(successfulOptions));

        dispatch(goBack());
      }
    } catch (error) {
      handleError(error, dispatch);
    }
  };
};

// activate brand api
export const activateBrand = (id, value) => {
  return async (dispatch, getState) => {
    try {
      const response = await axios.put(`${API_URL}/brand/${id}/active`, {
        brand: {
          isActive: value
        }
      });

      const successfulOptions = {
        title: `${response.data.message}`,
        position: 'tr',
        autoDismiss: 1
      };

      if (response.data.success === true) {
        dispatch(success(successfulOptions));

        const brand = getState().brand.brand;
        dispatch(fetchBrand(brand._id));
      }
    } catch (error) {
      handleError(error, dispatch);
    }
  };
};

// delete brand api
export const deleteBrand = id => {
  return async (dispatch, getState) => {
    try {
      const response = await axios.delete(`${API_URL}/brand/delete/${id}`);

      const successfulOptions = {
        title: `${response.data.message}`,
        position: 'tr',
        autoDismiss: 1
      };

      if (response.data.success === true) {
        dispatch(success(successfulOptions));
        dispatch({
          type: REMOVE_BRAND,
          payload: id
        });
        dispatch(goBack());
      }
    } catch (error) {
      handleError(error, dispatch);
    }
  };
};
</file>
<file name="./client/app/containers/Brand/List.js" format="js">
/*
 *
 * List
 *
 */

import React from 'react';

import { connect } from 'react-redux';

import actions from '../../actions';
import { ROLES } from '../../constants';

import BrandList from '../../components/Manager/BrandList';
import SubPage from '../../components/Manager/SubPage';
import LoadingIndicator from '../../components/Common/LoadingIndicator';
import NotFound from '../../components/Common/NotFound';

class List extends React.PureComponent {
  componentDidMount() {
    this.props.fetchBrands();
  }

  render() {
    const { history, brands, isLoading, user } = this.props;

    return (
      <>
        <SubPage
          title={user.role === ROLES.Admin ? 'Brands' : 'Brand'}
          actionTitle={user.role === ROLES.Admin && 'Add'}
          handleAction={() => history.push('/dashboard/brand/add')}
        >
          {isLoading ? (
            <LoadingIndicator inline />
          ) : brands.length > 0 ? (
            <BrandList brands={brands} user={user} />
          ) : (
            <NotFound message='No brands found.' />
          )}
        </SubPage>
      </>
    );
  }
}

const mapStateToProps = state => {
  return {
    brands: state.brand.brands,
    isLoading: state.brand.isLoading,
    user: state.account.user
  };
};

export default connect(mapStateToProps, actions)(List);
</file>
<file name="./client/app/containers/AccountSecurity/index.js" format="js">
/*
 *
 * AccountSecurity
 *
 */

import React from 'react';
import { connect } from 'react-redux';

import actions from '../../actions';

import SubPage from '../../components/Manager/SubPage';
import ResetPasswordForm from '../../components/Common/ResetPasswordForm';

class AccountSecurity extends React.PureComponent {
  componentDidMount() {}

  render() {
    const {
      resetFormData,
      formErrors,
      resetPasswordChange,
      resetAccountPassword
    } = this.props;

    return (
      <div className='account-security'>
        <SubPage title={'Account Security'} isMenuOpen={null}>
          <div className='reset-form'>
            <h4>Reset Password</h4>
            <ResetPasswordForm
              resetFormData={resetFormData}
              formErrors={formErrors}
              resetPasswordChange={resetPasswordChange}
              resetPassword={resetAccountPassword}
            />
          </div>
        </SubPage>
      </div>
    );
  }
}

const mapStateToProps = state => {
  return {
    user: state.account.user,
    resetFormData: state.resetPassword.resetFormData,
    formErrors: state.resetPassword.formErrors
  };
};

export default connect(mapStateToProps, actions)(AccountSecurity);
</file>
<file name="./client/app/containers/Shop/constants.js" format="js">
/*
 *
 * Products constants
 *
 */

export const DEFAULT_ACTION = 'src/Products/DEFAULT_ACTION';
</file>
<file name="./client/app/containers/Shop/reducer.js" format="js">
/*
 *
 * Products reducer
 *
 */

import { DEFAULT_ACTION } from './constants';

const initialState = {};

const productsReducer = (state = initialState, action) => {
  switch (action.type) {
    case DEFAULT_ACTION:
      return {
        ...state
      };
    default:
      return state;
  }
};

export default productsReducer;
</file>
<file name="./client/app/containers/Shop/index.js" format="js">
/**
 *
 * Shop
 *
 */

import React from 'react';

import { connect } from 'react-redux';
import { Switch, Route } from 'react-router-dom';
import { Row, Col } from 'reactstrap';

import actions from '../../actions';
import { sortOptions } from '../../utils/store';

import ProductsShop from '../ProductsShop';
import BrandsShop from '../BrandsShop';
import CategoryShop from '../CategoryShop';

import Page404 from '../../components/Common/Page404';
import ProductFilter from '../../components/Store/ProductFilter';
import Pagination from '../../components/Common/Pagination';
import SelectOption from '../../components/Common/SelectOption';

class Shop extends React.PureComponent {
  componentDidMount() {
    document.body.classList.add('shop-page');
  }

  componentWillUnmount() {
    document.body.classList.remove('shop-page');
  }

  render() {
    const { products, advancedFilters, filterProducts } = this.props;
    const { totalPages, currentPage, count, limit, order } = advancedFilters;
    const displayPagination = totalPages > 1;
    const totalProducts = products.length;
    const left = limit * (currentPage - 1) + 1;
    const right = totalProducts + left - 1;

    return (
      <div className='shop'>
        <Row xs='12'>
          <Col
            xs={{ size: 12, order: 1 }}
            sm={{ size: 12, order: 1 }}
            md={{ size: 12, order: 1 }}
            lg={{ size: 3, order: 1 }}
          >
            <ProductFilter filterProducts={filterProducts} />
          </Col>
          <Col
            xs={{ size: 12, order: 2 }}
            sm={{ size: 12, order: 2 }}
            md={{ size: 12, order: 2 }}
            lg={{ size: 9, order: 2 }}
          >
            <Row className='align-items-center mx-0 mb-4 mt-4 mt-lg-0 py-3 py-lg-0 bg-white shop-toolbar'>
              <Col
                xs={{ size: 12, order: 1 }}
                sm={{ size: 12, order: 1 }}
                md={{ size: 5, order: 1 }}
                lg={{ size: 6, order: 1 }}
                className='text-center text-md-left mt-3 mt-md-0 mb-1 mb-md-0'
              >
                <span>Showing: </span>
                {totalProducts > 0
                  ? `${left}-${right} products of ${count} products`
                  : `${count} products`}
              </Col>
              <Col
                xs={{ size: 12, order: 2 }}
                sm={{ size: 12, order: 2 }}
                md={{ size: 2, order: 2 }}
                lg={{ size: 2, order: 2 }}
                className='text-right pr-0 d-none d-md-block'
              >
                <span>Sort by</span>
              </Col>
              <Col
                xs={{ size: 12, order: 2 }}
                sm={{ size: 12, order: 2 }}
                md={{ size: 5, order: 2 }}
                lg={{ size: 4, order: 2 }}
              >
                <SelectOption
                  name={'sorting'}
                  value={{ value: order, label: sortOptions[order].label }}
                  options={sortOptions}
                  handleSelectChange={(n, v) => {
                    filterProducts('sorting', n.value);
                  }}
                />
              </Col>
            </Row>
            <Switch>
              <Route exact path='/shop' component={ProductsShop} />
              <Route path='/shop/category/:slug' component={CategoryShop} />
              <Route path='/shop/brand/:slug' component={BrandsShop} />
              <Route path='*' component={Page404} />
            </Switch>

            {displayPagination && (
              <div className='d-flex justify-content-center text-center mt-4'>
                <Pagination
                  totalPages={totalPages}
                  onPagination={filterProducts}
                />
              </div>
            )}
          </Col>
        </Row>
      </div>
    );
  }
}

const mapStateToProps = state => {
  return {
    advancedFilters: state.product.advancedFilters,
    products: state.product.storeProducts
  };
};

export default connect(mapStateToProps, actions)(Shop);
</file>
<file name="./client/app/containers/Shop/actions.js" format="js">
/*
 *
 * Shop actions
 *
 */

import { DEFAULT_ACTION } from './constants';

export const defaultAction = () => {
  return {
    type: DEFAULT_ACTION
  };
};
</file>
<file name="./client/app/containers/Notification/index.js" format="js">
/**
 *
 * Notification
 *
 */

import React from 'react';

import { connect } from 'react-redux';
import Notifications from 'react-notification-system-redux';

import actions from '../../actions';

class Notification extends React.PureComponent {
  componentDidMount() {}

  render() {
    const { notifications } = this.props;

    const style = {
      NotificationItem: {
        DefaultStyle: {
          margin: '10px 5px 2px 1px'
        },

        success: {
          color: 'red'
        }
      }
    };
    return <Notifications notifications={notifications} style={style} />;
  }
}

const mapStateToProps = state => {
  return {
    notifications: state.notifications
  };
};

export default connect(mapStateToProps, actions)(Notification);
</file>
<file name="./client/app/containers/Sell/index.js" format="js">
/*
 *
 * Sell
 *
 */

import React from 'react';

import { connect } from 'react-redux';
import { Row, Col } from 'reactstrap';

import actions from '../../actions';

import LoadingIndicator from '../../components/Common/LoadingIndicator';
import AddMerchant from '../../components/Manager/AddMerchant';

class Sell extends React.PureComponent {
  render() {
    const {
      merchantFormData,
      formErrors,
      merchantChange,
      addMerchant,
      isSubmitting,
      isLoading
    } = this.props;

    return (
      <div className='sell'>
        {isLoading && <LoadingIndicator />}
        <h3 className='text-uppercase'>Become A MERN Store Seller!</h3>
        <hr />
        <Row>
          <Col xs='12' md='6' className='order-2 order-md-1'>
            <AddMerchant
              merchantFormData={merchantFormData}
              formErrors={formErrors}
              isSubmitting={isSubmitting}
              submitTitle='Submit'
              merchantChange={merchantChange}
              addMerchant={addMerchant}
            />
          </Col>
          <Col xs='12' md='6' className='order-1 order-md-2'>
            <Row>
              <Col xs='12' className='order-2 order-md-1 text-md-center mb-3'>
                <div className='agreement-banner-text'>
                  <h3>Would you like to sell your products on MERN Store!</h3>
                  <h5>Grow your business with MERN Store</h5>
                  <b>Apply Today</b>
                </div>
              </Col>

              <Col
                xs='12'
                className='order-1 order-md-2 text-center mb-3 mb-md-0'
              >
                <img
                  className='agreement-banner'
                  src={'/images/banners/agreement.svg'}
                  alt='agreement banner'
                />
              </Col>
            </Row>
          </Col>
        </Row>
      </div>
    );
  }
}

const mapStateToProps = state => {
  return {
    merchantFormData: state.merchant.merchantFormData,
    formErrors: state.merchant.formErrors,
    isSubmitting: state.merchant.isSubmitting,
    isLoading: state.merchant.isLoading
  };
};

export default connect(mapStateToProps, actions)(Sell);
</file>
<file name="./client/app/containers/Order/constants.js" format="js">
/*
 *
 * Order constants
 *
 */

export const FETCH_ORDERS = 'src/Orders/FETCH_ORDERS';
export const FETCH_SEARCHED_ORDERS = 'src/Orders/FETCH_SEARCHED_ORDERS';
export const FETCH_ORDER = 'src/Order/FETCH_ORDER';
export const UPDATE_ORDER_STATUS = 'src/Order/UPDATE_ORDER_STATUS';
export const SET_ORDERS_LOADING = 'src/Orders/SET_ORDERS_LOADING';
export const SET_ADVANCED_FILTERS = 'src/Orders/SET_ADVANCED_FILTERS';
export const CLEAR_ORDERS = 'src/Orders/CLEAR_ORDERS';
</file>
<file name="./client/app/containers/Order/reducer.js" format="js">
/*
 *
 * Order reducer
 *
 */

import {
  FETCH_ORDERS,
  FETCH_SEARCHED_ORDERS,
  FETCH_ORDER,
  UPDATE_ORDER_STATUS,
  SET_ORDERS_LOADING,
  SET_ADVANCED_FILTERS,
  CLEAR_ORDERS
} from './constants';

const initialState = {
  orders: [],
  searchedOrders: [],
  order: {
    _id: '',
    cartId: '',
    products: [],
    totalTax: 0,
    total: 0,
    status: ''
  },
  isLoading: false,
  advancedFilters: {
    totalPages: 1,
    currentPage: 1,
    count: 0
  }
};

const orderReducer = (state = initialState, action) => {
  switch (action.type) {
    case FETCH_ORDERS:
      return {
        ...state,
        orders: action.payload
      };
    case FETCH_SEARCHED_ORDERS:
      return {
        ...state,
        searchedOrders: action.payload
      };
    case FETCH_ORDER:
      return {
        ...state,
        order: action.payload
      };
    case SET_ADVANCED_FILTERS:
      return {
        ...state,
        advancedFilters: {
          ...state.advancedFilters,
          ...action.payload
        }
      };
    case UPDATE_ORDER_STATUS:
      const itemIndex = state.order.products.findIndex(
        item => item._id === action.payload.itemId
      );

      const newProducts = [...state.order.products];
      newProducts[itemIndex].status = action.payload.status;
      return {
        ...state,
        order: {
          ...state.order,
          products: newProducts
        }
      };
    case SET_ORDERS_LOADING:
      return {
        ...state,
        isLoading: action.payload
      };
    case CLEAR_ORDERS:
      return {
        ...state,
        orders: []
      };
    default:
      return state;
  }
};

export default orderReducer;
</file>
<file name="./client/app/containers/Order/Customer.js" format="js">
/*
 *
 * Customer
 *
 */

import React from 'react';

import { connect } from 'react-redux';

import actions from '../../actions';
import { ROLES } from '../../constants';
import SubPage from '../../components/Manager/SubPage';
import OrderList from '../../components/Manager/OrderList';
import OrderSearch from '../../components/Manager/OrderSearch';
import SearchResultMeta from '../../components/Manager/SearchResultMeta';
import NotFound from '../../components/Common/NotFound';
import LoadingIndicator from '../../components/Common/LoadingIndicator';
import Pagination from '../../components/Common/Pagination';

class Customer extends React.PureComponent {
  constructor(props) {
    super(props);

    this.state = {
      search: ''
    };
  }

  componentDidMount() {
    this.props.fetchOrders();
  }

  handleOrderSearch = e => {
    if (e.value.length >= 2) {
      this.props.searchOrders({ name: 'order', value: e.value });
      this.setState({
        search: e.value
      });
    } else {
      this.setState({
        search: ''
      });
    }
  };

  handleOnPagination = (n, v) => {
    this.props.fetchOrders(v);
  };

  render() {
    const {
      history,
      user,
      orders,
      isLoading,
      searchedOrders,
      advancedFilters,
      searchOrders
    } = this.props;
    const { search } = this.state;
    const isSearch = search.length > 0;
    const filteredOrders = search ? searchedOrders : orders;
    const displayPagination = advancedFilters.totalPages > 1;
    const displayOrders = filteredOrders && filteredOrders.length > 0;

    return (
      <div className='order-dashboard'>
        <SubPage
          title='Customer Orders'
          actionTitle='My Orders'
          handleAction={() =>
            user.role === ROLES.Admin && history.push('/dashboard/orders')
          }
        >
          <OrderSearch
            onSearch={this.handleOrderSearch}
            onSearchSubmit={searchOrders}
          />
          {isLoading && <LoadingIndicator />}
          {displayOrders && (
            <>
              {!isSearch && displayPagination && (
                <Pagination
                  totalPages={advancedFilters.totalPages}
                  onPagination={this.handleOnPagination}
                />
              )}

              <SearchResultMeta
                label='orders'
                count={isSearch ? filteredOrders.length : advancedFilters.count}
              />
              <OrderList orders={filteredOrders} />
            </>
          )}
          {!isLoading && !displayOrders && (
            <NotFound message='No orders found.' />
          )}
        </SubPage>
      </div>
    );
  }
}

const mapStateToProps = state => {
  return {
    user: state.account.user,
    orders: state.order.orders,
    searchedOrders: state.order.searchedOrders,
    isLoading: state.order.isLoading,
    advancedFilters: state.order.advancedFilters,
    isOrderAddOpen: state.order.isOrderAddOpen
  };
};

export default connect(mapStateToProps, actions)(Customer);
</file>
<file name="./client/app/containers/Order/index.js" format="js">
/*
 *
 * Order
 *
 */

import React from 'react';

import { connect } from 'react-redux';
import { Switch, Route } from 'react-router-dom';

import { ROLES } from '../../constants';
import actions from '../../actions';
import List from './List';
import Customer from './Customer';
import Page404 from '../../components/Common/Page404';

class Order extends React.PureComponent {
  render() {
    const { user } = this.props;

    return (
      <div className='product-dashboard'>
        <Switch>
          <Route exact path='/dashboard/orders' component={List} />
          {user.role === ROLES.Admin && (
            <Route
              exact
              path='/dashboard/orders/customers'
              component={Customer}
            />
          )}
          <Route path='*' component={Page404} />
        </Switch>
      </div>
    );
  }
}

const mapStateToProps = state => {
  return {
    user: state.account.user
  };
};

export default connect(mapStateToProps, actions)(Order);
</file>
<file name="./client/app/containers/Order/actions.js" format="js">
/*
 *
 * Order actions
 *
 */

import { push } from 'connected-react-router';
import axios from 'axios';
import { success } from 'react-notification-system-redux';

import {
  FETCH_ORDERS,
  FETCH_SEARCHED_ORDERS,
  FETCH_ORDER,
  UPDATE_ORDER_STATUS,
  SET_ORDERS_LOADING,
  SET_ADVANCED_FILTERS,
  CLEAR_ORDERS
} from './constants';

import { clearCart, getCartId } from '../Cart/actions';
import { toggleCart } from '../Navigation/actions';
import handleError from '../../utils/error';
import { API_URL } from '../../constants';

export const updateOrderStatus = value => {
  return {
    type: UPDATE_ORDER_STATUS,
    payload: value
  };
};

export const setOrderLoading = value => {
  return {
    type: SET_ORDERS_LOADING,
    payload: value
  };
};

export const fetchOrders = (page = 1) => {
  return async (dispatch, getState) => {
    try {
      dispatch(setOrderLoading(true));

      const response = await axios.get(`${API_URL}/order`, {
        params: {
          page: page ?? 1,
          limit: 20
        }
      });

      const { orders, totalPages, currentPage, count } = response.data;

      dispatch({
        type: FETCH_ORDERS,
        payload: orders
      });

      dispatch({
        type: SET_ADVANCED_FILTERS,
        payload: { totalPages, currentPage, count }
      });
    } catch (error) {
      dispatch(clearOrders());
      handleError(error, dispatch);
    } finally {
      dispatch(setOrderLoading(false));
    }
  };
};

export const fetchAccountOrders = (page = 1) => {
  return async (dispatch, getState) => {
    try {
      dispatch(setOrderLoading(true));

      const response = await axios.get(`${API_URL}/order/me`, {
        params: {
          page: page ?? 1,
          limit: 20
        }
      });

      const { orders, totalPages, currentPage, count } = response.data;

      dispatch({
        type: FETCH_ORDERS,
        payload: orders
      });

      dispatch({
        type: SET_ADVANCED_FILTERS,
        payload: { totalPages, currentPage, count }
      });
    } catch (error) {
      dispatch(clearOrders());
      handleError(error, dispatch);
    } finally {
      dispatch(setOrderLoading(false));
    }
  };
};

export const searchOrders = filter => {
  return async (dispatch, getState) => {
    try {
      dispatch(setOrderLoading(true));

      const response = await axios.get(`${API_URL}/order/search`, {
        params: {
          search: filter.value
        }
      });

      dispatch({
        type: FETCH_SEARCHED_ORDERS,
        payload: response.data.orders
      });
    } catch (error) {
      handleError(error, dispatch);
    } finally {
      dispatch(setOrderLoading(false));
    }
  };
};

export const fetchOrder = (id, withLoading = true) => {
  return async (dispatch, getState) => {
    try {
      if (withLoading) {
        dispatch(setOrderLoading(true));
      }

      const response = await axios.get(`${API_URL}/order/${id}`);

      dispatch({
        type: FETCH_ORDER,
        payload: response.data.order
      });
    } catch (error) {
      handleError(error, dispatch);
    } finally {
      if (withLoading) {
        dispatch(setOrderLoading(false));
      }
    }
  };
};

export const cancelOrder = () => {
  return async (dispatch, getState) => {
    try {
      const order = getState().order.order;

      await axios.delete(`${API_URL}/order/cancel/${order._id}`);

      dispatch(push(`/dashboard/orders`));
    } catch (error) {
      handleError(error, dispatch);
    }
  };
};

export const updateOrderItemStatus = (itemId, status) => {
  return async (dispatch, getState) => {
    try {
      const order = getState().order.order;

      const response = await axios.put(
        `${API_URL}/order/status/item/${itemId}`,
        {
          orderId: order._id,
          cartId: order.cartId,
          status
        }
      );

      if (response.data.orderCancelled) {
        dispatch(push(`/dashboard/orders`));
      } else {
        dispatch(updateOrderStatus({ itemId, status }));
        dispatch(fetchOrder(order._id, false));
      }

      const successfulOptions = {
        title: `${response.data.message}`,
        position: 'tr',
        autoDismiss: 1
      };

      dispatch(success(successfulOptions));
    } catch (error) {
      handleError(error, dispatch);
    }
  };
};

export const addOrder = () => {
  return async (dispatch, getState) => {
    try {
      const cartId = localStorage.getItem('cart_id');
      const total = getState().cart.cartTotal;

      if (cartId) {
        const response = await axios.post(`${API_URL}/order/add`, {
          cartId,
          total
        });

        dispatch(push(`/order/success/${response.data.order._id}`));
        dispatch(clearCart());
      }
    } catch (error) {
      handleError(error, dispatch);
    }
  };
};

export const placeOrder = () => {
  return (dispatch, getState) => {
    const token = localStorage.getItem('token');

    const cartItems = getState().cart.cartItems;

    if (token && cartItems.length > 0) {
      Promise.all([dispatch(getCartId())]).then(() => {
        dispatch(addOrder());
      });
    }

    dispatch(toggleCart());
  };
};

export const clearOrders = () => {
  return {
    type: CLEAR_ORDERS
  };
};
</file>
<file name="./client/app/containers/Order/List.js" format="js">
/*
 *
 * List
 *
 */

import React from 'react';

import { connect } from 'react-redux';

import actions from '../../actions';
import { ROLES } from '../../constants';
import SubPage from '../../components/Manager/SubPage';
import OrderList from '../../components/Manager/OrderList';
import OrderSearch from '../../components/Manager/OrderSearch';
import SearchResultMeta from '../../components/Manager/SearchResultMeta';
import NotFound from '../../components/Common/NotFound';
import LoadingIndicator from '../../components/Common/LoadingIndicator';
import Pagination from '../../components/Common/Pagination';

class List extends React.PureComponent {
  constructor(props) {
    super(props);

    this.state = {
      search: ''
    };
  }

  componentDidMount() {
    this.props.fetchAccountOrders();
  }

  handleOrderSearch = e => {
    if (e.value.length >= 2) {
      this.setState({
        search: e.value
      });
    } else {
      this.setState({
        search: ''
      });
    }
  };

  handleOnPagination = (n, v) => {
    this.props.fetchAccountOrders(v);
  };

  render() {
    const { history, user, orders, isLoading, advancedFilters } = this.props;
    const { search } = this.state;
    const isSearch = search.length > 0;
    const filteredOrders = search
      ? orders.filter(o => o._id.includes(search))
      : orders;

    const displayPagination = advancedFilters.totalPages > 1;
    const displayOrders = filteredOrders && filteredOrders.length > 0;

    return (
      <div className='order-dashboard'>
        <SubPage
          title='Your Orders'
          actionTitle={user.role === ROLES.Admin && 'Customer Orders'}
          handleAction={() =>
            user.role === ROLES.Admin &&
            history.push('/dashboard/orders/customers')
          }
        >
          <OrderSearch
            onBlur={this.handleOrderSearch}
            onSearch={this.handleOrderSearch}
            onSearchSubmit={this.handleOrderSearch}
          />

          {isLoading && <LoadingIndicator />}
          {displayOrders && (
            <>
              {!isSearch && displayPagination && (
                <Pagination
                  totalPages={advancedFilters.totalPages}
                  onPagination={this.handleOnPagination}
                />
              )}

              <SearchResultMeta
                label='orders'
                count={isSearch ? filteredOrders.length : advancedFilters.count}
              />
              <OrderList orders={filteredOrders} />
            </>
          )}
          {!isLoading && !displayOrders && (
            <NotFound message='You have no orders yet.' />
          )}
        </SubPage>
      </div>
    );
  }
}

const mapStateToProps = state => {
  return {
    user: state.account.user,
    orders: state.order.orders,
    isLoading: state.order.isLoading,
    advancedFilters: state.order.advancedFilters,
    isOrderAddOpen: state.order.isOrderAddOpen
  };
};

export default connect(mapStateToProps, actions)(List);
</file>
<file name="./client/app/containers/Product/constants.js" format="js">
/*
 *
 * Product constants
 *
 */

export const FETCH_PRODUCTS = 'src/Product/FETCH_PRODUCTS';
export const FETCH_STORE_PRODUCTS = 'src/Product/FETCH_STORE_PRODUCTS';
export const FETCH_PRODUCT = 'src/Product/FETCH_PRODUCT';
export const FETCH_STORE_PRODUCT = 'src/Product/FETCH_STORE_PRODUCT';
export const PRODUCT_CHANGE = 'src/Product/PRODUCT_CHANGE';
export const PRODUCT_EDIT_CHANGE = 'src/Product/PRODUCT_EDIT_CHANGE';
export const PRODUCT_SHOP_CHANGE = 'src/Product/PRODUCT_SHOP_CHANGE';
export const SET_PRODUCT_FORM_ERRORS = 'src/Product/SET_PRODUCT_FORM_ERRORS';
export const SET_PRODUCT_FORM_EDIT_ERRORS =
  'src/Product/SET_PRODUCT_FORM_EDIT_ERRORS';
export const SET_PRODUCT_SHOP_FORM_ERRORS =
  'src/Product/SET_PRODUCT_SHOP_FORM_ERRORS';
export const RESET_PRODUCT = 'src/Product/RESET_PRODUCT';
export const RESET_PRODUCT_SHOP = 'src/Product/RESET_PRODUCT_SHOP';
export const ADD_PRODUCT = 'src/Product/ADD_PRODUCT';
export const REMOVE_PRODUCT = 'src/Product/REMOVE_PRODUCT';
export const FETCH_PRODUCTS_SELECT = 'src/Product/FETCH_PRODUCTS_SELECT';
export const SET_PRODUCTS_LOADING = 'src/Product/SET_PRODUCTS_LOADING';
export const SET_ADVANCED_FILTERS = 'src/Product/SET_ADVANCED_FILTERS';
export const RESET_ADVANCED_FILTERS = 'src/Product/RESET_ADVANCED_FILTERS';
</file>
<file name="./client/app/containers/Product/reducer.js" format="js">
/*
 *
 * Product reducer
 *
 */

import {
  FETCH_PRODUCTS,
  FETCH_STORE_PRODUCTS,
  FETCH_PRODUCT,
  FETCH_STORE_PRODUCT,
  PRODUCT_CHANGE,
  PRODUCT_EDIT_CHANGE,
  PRODUCT_SHOP_CHANGE,
  SET_PRODUCT_FORM_ERRORS,
  SET_PRODUCT_FORM_EDIT_ERRORS,
  SET_PRODUCT_SHOP_FORM_ERRORS,
  RESET_PRODUCT,
  RESET_PRODUCT_SHOP,
  ADD_PRODUCT,
  REMOVE_PRODUCT,
  FETCH_PRODUCTS_SELECT,
  SET_PRODUCTS_LOADING,
  SET_ADVANCED_FILTERS,
  RESET_ADVANCED_FILTERS
} from './constants';

const initialState = {
  products: [],
  storeProducts: [],
  product: {
    _id: ''
  },
  storeProduct: {},
  productsSelect: [],
  productFormData: {
    sku: '',
    name: '',
    description: '',
    quantity: 1,
    price: 1,
    image: {},
    isActive: true,
    taxable: { value: 0, label: 'No' },
    brand: {
      value: 0,
      label: 'No Options Selected'
    }
  },
  isLoading: false,
  productShopData: {
    quantity: 1
  },
  formErrors: {},
  editFormErrors: {},
  shopFormErrors: {},
  advancedFilters: {
    name: 'all',
    category: 'all',
    brand: 'all',
    min: 1,
    max: 2500,
    rating: 0,
    order: 0,
    totalPages: 1,
    currentPage: 1,
    count: 0,
    limit: 10
  }
};

const productReducer = (state = initialState, action) => {
  switch (action.type) {
    case FETCH_PRODUCTS:
      return {
        ...state,
        products: action.payload
      };
    case FETCH_STORE_PRODUCTS:
      return {
        ...state,
        storeProducts: action.payload
      };
    case FETCH_PRODUCT:
      return {
        ...state,
        product: action.payload,
        editFormErrors: {}
      };
    case FETCH_STORE_PRODUCT:
      return {
        ...state,
        storeProduct: action.payload,
        productShopData: {
          quantity: 1
        },
        shopFormErrors: {}
      };
    case SET_PRODUCTS_LOADING:
      return {
        ...state,
        isLoading: action.payload
      };
    case FETCH_PRODUCTS_SELECT:
      return { ...state, productsSelect: action.payload };
    case ADD_PRODUCT:
      return {
        ...state,
        products: [...state.products, action.payload]
      };
    case REMOVE_PRODUCT:
      const index = state.products.findIndex(b => b._id === action.payload);
      return {
        ...state,
        products: [
          ...state.products.slice(0, index),
          ...state.products.slice(index + 1)
        ]
      };
    case PRODUCT_CHANGE:
      return {
        ...state,
        productFormData: {
          ...state.productFormData,
          ...action.payload
        }
      };
    case PRODUCT_EDIT_CHANGE:
      return {
        ...state,
        product: {
          ...state.product,
          ...action.payload
        }
      };
    case PRODUCT_SHOP_CHANGE:
      return {
        ...state,
        productShopData: {
          ...state.productShopData,
          ...action.payload
        }
      };
    case SET_PRODUCT_FORM_ERRORS:
      return {
        ...state,
        formErrors: action.payload
      };
    case SET_PRODUCT_FORM_EDIT_ERRORS:
      return {
        ...state,
        editFormErrors: action.payload
      };
    case SET_PRODUCT_SHOP_FORM_ERRORS:
      return {
        ...state,
        shopFormErrors: action.payload
      };
    case RESET_PRODUCT:
      return {
        ...state,
        productFormData: {
          sku: '',
          name: '',
          description: '',
          quantity: 1,
          price: 1,
          image: {},
          isActive: true,
          taxable: { value: 0, label: 'No' },
          brand: {
            value: 0,
            label: 'No Options Selected'
          }
        },
        product: {
          _id: ''
        },
        formErrors: {}
      };
    case RESET_PRODUCT_SHOP:
      return {
        ...state,
        productShopData: {
          quantity: 1
        },
        shopFormErrors: {}
      };
    case SET_ADVANCED_FILTERS:
      return {
        ...state,
        advancedFilters: {
          ...state.advancedFilters,
          ...action.payload
        }
      };
    case RESET_ADVANCED_FILTERS:
      return {
        ...state,
        advancedFilters: {
          name: 'all',
          category: 'all',
          brand: 'all',
          min: 1,
          max: 2500,
          rating: 0,
          order: 0,
          totalPages: 1,
          currentPage: 1,
          count: 0,
          limit: 10
        }
      };
    default:
      return state;
  }
};

export default productReducer;
</file>
<file name="./client/app/containers/Product/Edit.js" format="js">
/*
 *
 * Edit
 *
 */

import React from 'react';

import { connect } from 'react-redux';

import actions from '../../actions';

import EditProduct from '../../components/Manager/EditProduct';
import SubPage from '../../components/Manager/SubPage';
import NotFound from '../../components/Common/NotFound';

class Edit extends React.PureComponent {
  componentDidMount() {
    this.props.resetProduct();
    const productId = this.props.match.params.id;
    this.props.fetchProduct(productId);
    this.props.fetchBrandsSelect();
  }

  componentDidUpdate(prevProps) {
    if (this.props.match.params.id !== prevProps.match.params.id) {
      this.props.resetProduct();
      const productId = this.props.match.params.id;
      this.props.fetchProduct(productId);
    }
  }

  render() {
    const {
      history,
      user,
      product,
      formErrors,
      brands,
      productEditChange,
      updateProduct,
      deleteProduct,
      activateProduct
    } = this.props;

    return (
      <SubPage
        title='Edit Product'
        actionTitle='Cancel'
        handleAction={history.goBack}
      >
        {product?._id ? (
          <EditProduct
            user={user}
            product={product}
            formErrors={formErrors}
            brands={brands}
            productChange={productEditChange}
            updateProduct={updateProduct}
            deleteProduct={deleteProduct}
            activateProduct={activateProduct}
          />
        ) : (
          <NotFound message='No product found.' />
        )}
      </SubPage>
    );
  }
}

const mapStateToProps = state => {
  return {
    user: state.account.user,
    product: state.product.product,
    formErrors: state.product.editFormErrors,
    brands: state.brand.brandsSelect
  };
};

export default connect(mapStateToProps, actions)(Edit);
</file>
<file name="./client/app/containers/Product/index.js" format="js">
/*
 *
 * Product
 *
 */

import React from 'react';

import { connect } from 'react-redux';
import { Switch, Route } from 'react-router-dom';

import actions from '../../actions';

// import { ROLES } from '../../constants';
import List from './List';
import Add from './Add';
import Edit from './Edit';
import Page404 from '../../components/Common/Page404';

class Product extends React.PureComponent {
  render() {
    const { user } = this.props;

    return (
      <div className='product-dashboard'>
        <Switch>
          <Route exact path='/dashboard/product' component={List} />
          <Route exact path='/dashboard/product/edit/:id' component={Edit} />
          {/* {user.role === ROLES.Admin && ( */}
          <Route exact path='/dashboard/product/add' component={Add} />
          {/* )} */}
          <Route path='*' component={Page404} />
        </Switch>
      </div>
    );
  }
}

const mapStateToProps = state => {
  return {
    user: state.account.user
  };
};

export default connect(mapStateToProps, actions)(Product);
</file>
<file name="./client/app/containers/Product/Add.js" format="js">
/*
 *
 * Add
 *
 */

import React from 'react';

import { connect } from 'react-redux';

import actions from '../../actions';

import AddProduct from '../../components/Manager/AddProduct';
import SubPage from '../../components/Manager/SubPage';

class Add extends React.PureComponent {
  componentDidMount() {
    this.props.fetchBrandsSelect();
  }

  render() {
    const {
      history,
      user,
      productFormData,
      formErrors,
      brands,
      productChange,
      addProduct
    } = this.props;

    return (
      <SubPage
        title='Add Product'
        actionTitle='Cancel'
        handleAction={() => history.goBack()}
      >
        <AddProduct
          user={user}
          productFormData={productFormData}
          formErrors={formErrors}
          brands={brands}
          productChange={productChange}
          addProduct={addProduct}
        />
      </SubPage>
    );
  }
}

const mapStateToProps = state => {
  return {
    user: state.account.user,
    productFormData: state.product.productFormData,
    formErrors: state.product.formErrors,
    brands: state.brand.brandsSelect
  };
};

export default connect(mapStateToProps, actions)(Add);
</file>
<file name="./client/app/containers/Product/actions.js" format="js">
/*
 *
 * Product actions
 *
 */

import { goBack } from 'connected-react-router';
import { success } from 'react-notification-system-redux';
import axios from 'axios';

import {
  FETCH_PRODUCTS,
  FETCH_STORE_PRODUCTS,
  FETCH_PRODUCT,
  FETCH_STORE_PRODUCT,
  PRODUCT_CHANGE,
  PRODUCT_EDIT_CHANGE,
  PRODUCT_SHOP_CHANGE,
  SET_PRODUCT_FORM_ERRORS,
  SET_PRODUCT_FORM_EDIT_ERRORS,
  RESET_PRODUCT,
  ADD_PRODUCT,
  REMOVE_PRODUCT,
  FETCH_PRODUCTS_SELECT,
  SET_PRODUCTS_LOADING,
  SET_ADVANCED_FILTERS,
  RESET_ADVANCED_FILTERS
} from './constants';

import { API_URL, ROLES } from '../../constants';
import handleError from '../../utils/error';
import { formatSelectOptions, unformatSelectOptions } from '../../utils/select';
import { allFieldsValidation } from '../../utils/validation';

export const productChange = (name, value) => {
  let formData = {};
  formData[name] = value;
  return {
    type: PRODUCT_CHANGE,
    payload: formData
  };
};

export const productEditChange = (name, value) => {
  let formData = {};
  formData[name] = value;

  return {
    type: PRODUCT_EDIT_CHANGE,
    payload: formData
  };
};

export const productShopChange = (name, value) => {
  let formData = {};
  formData[name] = value;

  return {
    type: PRODUCT_SHOP_CHANGE,
    payload: formData
  };
};

export const resetProduct = () => {
  return async (dispatch, getState) => {
    dispatch({ type: RESET_PRODUCT });
  };
};

export const setProductLoading = value => {
  return {
    type: SET_PRODUCTS_LOADING,
    payload: value
  };
};

// fetch store products by filterProducts api
export const filterProducts = (n, v) => {
  return async (dispatch, getState) => {
    try {
      n ?? dispatch({ type: RESET_ADVANCED_FILTERS });

      dispatch(setProductLoading(true));
      const advancedFilters = getState().product.advancedFilters;
      let payload = productsFilterOrganizer(n, v, advancedFilters);
      dispatch({ type: SET_ADVANCED_FILTERS, payload });
      const sortOrder = getSortOrder(payload.order);
      payload = { ...payload, sortOrder };

      const response = await axios.get(`${API_URL}/product/list`, {
        params: {
          ...payload
        }
      });
      const { products, totalPages, currentPage, count } = response.data;

      dispatch({
        type: FETCH_STORE_PRODUCTS,
        payload: products
      });

      const newPayload = {
        ...payload,
        totalPages,
        currentPage,
        count
      };
      dispatch({
        type: SET_ADVANCED_FILTERS,
        payload: newPayload
      });
    } catch (error) {
      handleError(error, dispatch);
    } finally {
      dispatch(setProductLoading(false));
    }
  };
};

// fetch store product api
export const fetchStoreProduct = slug => {
  return async (dispatch, getState) => {
    dispatch(setProductLoading(true));

    try {
      const response = await axios.get(`${API_URL}/product/item/${slug}`);

      const inventory = response.data.product.quantity;
      const product = { ...response.data.product, inventory };

      dispatch({
        type: FETCH_STORE_PRODUCT,
        payload: product
      });
    } catch (error) {
      handleError(error, dispatch);
    } finally {
      dispatch(setProductLoading(false));
    }
  };
};

export const fetchBrandProducts = slug => {
  return async (dispatch, getState) => {
    try {
      dispatch(setProductLoading(true));

      const response = await axios.get(`${API_URL}/product/list/brand/${slug}`);

      const s = getState().product.advancedFilters;
      dispatch({
        type: SET_ADVANCED_FILTERS,
        payload: Object.assign(s, {
          pages: response.data.pages,
          pageNumber: response.data.page,
          totalProducts: response.data.totalProducts
        })
      });
      dispatch({
        type: FETCH_STORE_PRODUCTS,
        payload: response.data.products
      });
    } catch (error) {
      handleError(error, dispatch);
    } finally {
      dispatch(setProductLoading(false));
    }
  };
};

export const fetchProductsSelect = () => {
  return async (dispatch, getState) => {
    try {
      const response = await axios.get(`${API_URL}/product/list/select`);

      const formattedProducts = formatSelectOptions(response.data.products);

      dispatch({
        type: FETCH_PRODUCTS_SELECT,
        payload: formattedProducts
      });
    } catch (error) {
      handleError(error, dispatch);
    }
  };
};

// fetch products api
export const fetchProducts = () => {
  return async (dispatch, getState) => {
    try {
      dispatch(setProductLoading(true));

      const response = await axios.get(`${API_URL}/product`);

      dispatch({
        type: FETCH_PRODUCTS,
        payload: response.data.products
      });
    } catch (error) {
      handleError(error, dispatch);
    } finally {
      dispatch(setProductLoading(false));
    }
  };
};

// fetch product api
export const fetchProduct = id => {
  return async (dispatch, getState) => {
    try {
      const response = await axios.get(`${API_URL}/product/${id}`);

      const inventory = response.data.product.quantity;

      const brand = response.data.product.brand;
      const isBrand = brand ? true : false;
      const brandData = formatSelectOptions(
        isBrand && [brand],
        !isBrand,
        'fetchProduct'
      );

      response.data.product.brand = brandData[0];

      const product = { ...response.data.product, inventory };

      dispatch({
        type: FETCH_PRODUCT,
        payload: product
      });
    } catch (error) {
      handleError(error, dispatch);
    }
  };
};

// add product api
export const addProduct = () => {
  return async (dispatch, getState) => {
    try {
      const rules = {
        sku: 'required|alpha_dash',
        name: 'required',
        description: 'required|max:200',
        quantity: 'required|numeric',
        price: 'required|numeric',
        taxable: 'required',
        image: 'required',
        brand: 'required'
      };

      const product = getState().product.productFormData;
      const user = getState().account.user;
      const brands = getState().brand.brandsSelect;

      const brand = unformatSelectOptions([product.brand]);

      const newProduct = {
        sku: product.sku,
        name: product.name,
        description: product.description,
        price: product.price,
        quantity: product.quantity,
        image: product.image,
        isActive: product.isActive,
        taxable: product.taxable.value,
        brand:
          user.role !== ROLES.Merchant
            ? brand != 0
              ? brand
              : null
            : brands[1].value
      };

      const { isValid, errors } = allFieldsValidation(newProduct, rules, {
        'required.sku': 'Sku is required.',
        'alpha_dash.sku':
          'Sku may have alpha-numeric characters, as well as dashes and underscores only.',
        'required.name': 'Name is required.',
        'required.description': 'Description is required.',
        'max.description':
          'Description may not be greater than 200 characters.',
        'required.quantity': 'Quantity is required.',
        'required.price': 'Price is required.',
        'required.taxable': 'Taxable is required.',
        'required.image': 'Please upload files with jpg, jpeg, png format.',
        'required.brand': 'Brand is required.'
      });

      if (!isValid) {
        return dispatch({ type: SET_PRODUCT_FORM_ERRORS, payload: errors });
      }
      const formData = new FormData();
      if (newProduct.image) {
        for (const key in newProduct) {
          if (newProduct.hasOwnProperty(key)) {
            if (key === 'brand' && newProduct[key] === null) {
              continue;
            } else {
              formData.set(key, newProduct[key]);
            }
          }
        }
      }

      const response = await axios.post(`${API_URL}/product/add`, formData, {
        headers: { 'Content-Type': 'multipart/form-data' }
      });

      const successfulOptions = {
        title: `${response.data.message}`,
        position: 'tr',
        autoDismiss: 1
      };

      if (response.data.success === true) {
        dispatch(success(successfulOptions));
        dispatch({
          type: ADD_PRODUCT,
          payload: response.data.product
        });
        dispatch(resetProduct());
        dispatch(goBack());
      }
    } catch (error) {
      handleError(error, dispatch);
    }
  };
};

// update Product api
export const updateProduct = () => {
  return async (dispatch, getState) => {
    try {
      const rules = {
        name: 'required',
        sku: 'required|alpha_dash',
        slug: 'required|alpha_dash',
        description: 'required|max:200',
        quantity: 'required|numeric',
        price: 'required|numeric',
        taxable: 'required',
        brand: 'required'
      };

      const product = getState().product.product;

      const brand = unformatSelectOptions([product.brand]);

      const newProduct = {
        name: product.name,
        sku: product.sku,
        slug: product.slug,
        description: product.description,
        quantity: product.quantity,
        price: product.price,
        taxable: product.taxable,
        brand: brand != 0 ? brand : null
      };

      const { isValid, errors } = allFieldsValidation(newProduct, rules, {
        'required.name': 'Name is required.',
        'required.sku': 'Sku is required.',
        'alpha_dash.sku':
          'Sku may have alpha-numeric characters, as well as dashes and underscores only.',
        'required.slug': 'Slug is required.',
        'alpha_dash.slug':
          'Slug may have alpha-numeric characters, as well as dashes and underscores only.',
        'required.description': 'Description is required.',
        'max.description':
          'Description may not be greater than 200 characters.',
        'required.quantity': 'Quantity is required.',
        'required.price': 'Price is required.',
        'required.taxable': 'Taxable is required.',
        'required.brand': 'Brand is required.'
      });

      if (!isValid) {
        return dispatch({
          type: SET_PRODUCT_FORM_EDIT_ERRORS,
          payload: errors
        });
      }

      const response = await axios.put(`${API_URL}/product/${product._id}`, {
        product: newProduct
      });

      const successfulOptions = {
        title: `${response.data.message}`,
        position: 'tr',
        autoDismiss: 1
      };

      if (response.data.success === true) {
        dispatch(success(successfulOptions));

        //dispatch(goBack());
      }
    } catch (error) {
      handleError(error, dispatch);
    }
  };
};

// activate product api
export const activateProduct = (id, value) => {
  return async (dispatch, getState) => {
    try {
      const response = await axios.put(`${API_URL}/product/${id}/active`, {
        product: {
          isActive: value
        }
      });

      const successfulOptions = {
        title: `${response.data.message}`,
        position: 'tr',
        autoDismiss: 1
      };

      if (response.data.success === true) {
        dispatch(success(successfulOptions));
      }
    } catch (error) {
      handleError(error, dispatch);
    }
  };
};

// delete product api
export const deleteProduct = id => {
  return async (dispatch, getState) => {
    try {
      const response = await axios.delete(`${API_URL}/product/delete/${id}`);

      const successfulOptions = {
        title: `${response.data.message}`,
        position: 'tr',
        autoDismiss: 1
      };

      if (response.data.success === true) {
        dispatch(success(successfulOptions));
        dispatch({
          type: REMOVE_PRODUCT,
          payload: id
        });
        dispatch(goBack());
      }
    } catch (error) {
      handleError(error, dispatch);
    }
  };
};

const productsFilterOrganizer = (n, v, s) => {
  switch (n) {
    case 'category':
      return {
        name: s.name,
        category: v,
        brand: s.brand,
        min: s.min,
        max: s.max,
        rating: s.rating,
        order: s.order,
        page: s.currentPage,
        limit: s.limit
      };
    case 'brand':
      return {
        name: s.name,
        category: s.category,
        brand: v,
        min: s.min,
        max: s.max,
        rating: s.rating,
        order: s.order,
        page: s.currentPage,
        limit: s.limit
      };
    case 'sorting':
      return {
        name: s.name,
        category: s.category,
        brand: s.brand,
        min: s.min,
        max: s.max,
        rating: s.rating,
        order: v,
        page: s.currentPage,
        limit: s.limit
      };
    case 'price':
      return {
        name: s.name,
        category: s.category,
        brand: s.brand,
        min: v[0],
        max: v[1],
        rating: s.rating,
        order: s.order,
        page: s.currentPage,
        limit: s.limit
      };
    case 'rating':
      return {
        name: s.name,
        category: s.category,
        brand: s.brand,
        min: s.min,
        max: s.max,
        rating: v,
        order: s.order,
        page: s.currentPage,
        limit: s.limit
      };
    case 'pagination':
      return {
        name: s.name,
        category: s.category,
        brand: s.brand,
        min: s.min,
        max: s.max,
        rating: s.rating,
        order: s.order,
        page: v ?? s.currentPage,
        limit: s.limit
      };
    default:
      return {
        name: s.name,
        category: s.category,
        brand: s.brand,
        min: s.min,
        max: s.max,
        rating: s.rating,
        order: s.order,
        page: s.currentPage,
        limit: s.limit
      };
  }
};

const getSortOrder = value => {
  let sortOrder = {};
  switch (value) {
    case 0:
      sortOrder._id = -1;
      break;
    case 1:
      sortOrder.price = -1;
      break;
    case 2:
      sortOrder.price = 1;
      break;

    default:
      break;
  }

  return sortOrder;
};
</file>
<file name="./client/app/containers/Product/List.js" format="js">
/*
 *
 * List
 *
 */

import React from 'react';

import { connect } from 'react-redux';

import actions from '../../actions';

import ProductList from '../../components/Manager/ProductList';
import SubPage from '../../components/Manager/SubPage';
import LoadingIndicator from '../../components/Common/LoadingIndicator';
import NotFound from '../../components/Common/NotFound';

class List extends React.PureComponent {
  componentDidMount() {
    this.props.fetchProducts();
  }

  render() {
    const { history, products, isLoading } = this.props;

    return (
      <>
        <SubPage
          title='Products'
          actionTitle='Add'
          handleAction={() => history.push('/dashboard/product/add')}
        >
          {isLoading ? (
            <LoadingIndicator inline />
          ) : products.length > 0 ? (
            <ProductList products={products} />
          ) : (
            <NotFound message='No products found.' />
          )}
        </SubPage>
      </>
    );
  }
}

const mapStateToProps = state => {
  return {
    products: state.product.products,
    isLoading: state.product.isLoading,
    user: state.account.user
  };
};

export default connect(mapStateToProps, actions)(List);
</file>
<file name="./client/app/containers/Navigation/constants.js" format="js">
/*
 *
 * Navigation constants
 *
 */

export const TOGGLE_MENU = 'src/Navigation/TOGGLE_MENU';
export const TOGGLE_CART = 'src/Navigation/TOGGLE_CART';
export const TOGGLE_BRAND = 'src/Navigation/TOGGLE_BRAND';
export const SEARCH_CHANGE = 'src/Navigation/SEARCH_CHANGE';
export const SUGGESTIONS_FETCH_REQUEST =
  'src/Navigation/SUGGESTIONS_FETCH_REQUEST';
export const SUGGESTIONS_CLEAR_REQUEST =
  'src/Navigation/SUGGESTIONS_CLEAR_REQUEST';
</file>
<file name="./client/app/containers/Navigation/reducer.js" format="js">
/*
 *
 * Navigation reducer
 *
 */

import {
  TOGGLE_MENU,
  TOGGLE_CART,
  TOGGLE_BRAND,
  SEARCH_CHANGE,
  SUGGESTIONS_FETCH_REQUEST,
  SUGGESTIONS_CLEAR_REQUEST
} from './constants';

const initialState = {
  isMenuOpen: false,
  isCartOpen: false,
  isBrandOpen: false,
  searchValue: '',
  searchSuggestions: []
};

const navigationReducer = (state = initialState, action) => {
  switch (action.type) {
    case TOGGLE_MENU:
      return {
        ...state,
        isMenuOpen: !state.isMenuOpen,
        isCartOpen: false
      };
    case TOGGLE_CART:
      return {
        ...state,
        isCartOpen: !state.isCartOpen,
        isMenuOpen: false
      };
    case TOGGLE_BRAND:
      return {
        ...state,
        isBrandOpen: !state.isBrandOpen
      };
    case SEARCH_CHANGE:
      return {
        ...state,
        searchValue: action.payload
      };
    case SUGGESTIONS_FETCH_REQUEST:
      return {
        ...state,
        searchSuggestions: action.payload
      };
    case SUGGESTIONS_CLEAR_REQUEST:
      return {
        ...state,
        searchSuggestions: action.payload
      };
    default:
      return state;
  }
};

export default navigationReducer;
</file>
<file name="./client/app/containers/Navigation/index.js" format="js">
/**
 *
 * Navigation
 *
 */

import React from 'react';

import { connect } from 'react-redux';
import { Link, NavLink as ActiveLink, withRouter } from 'react-router-dom';
import Autosuggest from 'react-autosuggest';
import AutosuggestHighlightMatch from 'autosuggest-highlight/match';
import AutosuggestHighlightParse from 'autosuggest-highlight/parse';
import {
  Container,
  Row,
  Col,
  Navbar,
  Nav,
  NavItem,
  NavLink,
  UncontrolledDropdown,
  Dropdown,
  DropdownToggle,
  DropdownMenu,
  DropdownItem
} from 'reactstrap';

import actions from '../../actions';

import Button from '../../components/Common/Button';
import CartIcon from '../../components/Common/CartIcon';
import { BarsIcon } from '../../components/Common/Icon';
import MiniBrand from '../../components/Store//MiniBrand';
import Menu from '../NavigationMenu';
import Cart from '../Cart';

class Navigation extends React.PureComponent {
  componentDidMount() {
    this.props.fetchStoreBrands();
    this.props.fetchStoreCategories();
  }

  toggleBrand() {
    this.props.fetchStoreBrands();
    this.props.toggleBrand();
  }

  toggleMenu() {
    this.props.fetchStoreCategories();
    this.props.toggleMenu();
  }

  getSuggestionValue(suggestion) {
    return suggestion.name;
  }

  renderSuggestion(suggestion, { query, isHighlighted }) {
    const BoldName = (suggestion, query) => {
      const matches = AutosuggestHighlightMatch(suggestion.name, query);
      const parts = AutosuggestHighlightParse(suggestion.name, matches);

      return (
        <div>
          {parts.map((part, index) => {
            const className = part.highlight
              ? 'react-autosuggest__suggestion-match'
              : null;
            return (
              <span className={className} key={index}>
                {part.text}
              </span>
            );
          })}
        </div>
      );
    };

    return (
      <Link to={`/product/${suggestion.slug}`}>
        <div className='d-flex'>
          <img
            className='item-image'
            src={`${
              suggestion.imageUrl
                ? suggestion.imageUrl
                : '/images/placeholder-image.png'
            }`}
          />
          <div>
            <Container>
              <Row>
                <Col>
                  <span className='name'>{BoldName(suggestion, query)}</span>
                </Col>
              </Row>
              <Row>
                <Col>
                  <span className='price'>${suggestion.price}</span>
                </Col>
              </Row>
            </Container>
          </div>
        </div>
      </Link>
    );
  }

  render() {
    const {
      history,
      authenticated,
      user,
      cartItems,
      brands,
      categories,
      signOut,
      isMenuOpen,
      isCartOpen,
      isBrandOpen,
      toggleCart,
      toggleMenu,
      searchValue,
      suggestions,
      onSearch,
      onSuggestionsFetchRequested,
      onSuggestionsClearRequested
    } = this.props;

    const inputProps = {
      placeholder: 'Search Products',
      value: searchValue,
      onChange: (_, { newValue }) => {
        onSearch(newValue);
      }
    };

    return (
      <header className='header fixed-mobile-header'>
        <div className='header-info'>
          <Container>
            <Row>
              <Col md='4' className='text-center d-none d-md-block'>
                <i className='fa fa-truck' />
                <span>Free Shipping</span>
              </Col>
              <Col md='4' className='text-center d-none d-md-block'>
                <i className='fa fa-credit-card' />
                <span>Payment Methods</span>
              </Col>
              <Col md='4' className='text-center d-none d-md-block'>
                <i className='fa fa-phone' />
                <span>Call us 951-999-9999</span>
              </Col>
              <Col xs='12' className='text-center d-block d-md-none'>
                <i className='fa fa-phone' />
                <span> Need advice? Call us 951-999-9999</span>
              </Col>
            </Row>
          </Container>
        </div>
        <Container>
          <Row className='align-items-center top-header'>
            <Col
              xs={{ size: 12, order: 1 }}
              sm={{ size: 12, order: 1 }}
              md={{ size: 3, order: 1 }}
              lg={{ size: 3, order: 1 }}
              className='pr-0'
            >
              <div className='brand'>
                {categories && categories.length > 0 && (
                  <Button
                    borderless
                    variant='empty'
                    className='d-none d-md-block'
                    ariaLabel='open the menu'
                    icon={<BarsIcon />}
                    onClick={() => this.toggleMenu()}
                  />
                )}
                <Link to='/'>
                  <h1 className='logo'>MERN Store</h1>
                </Link>
              </div>
            </Col>
            <Col
              xs={{ size: 12, order: 4 }}
              sm={{ size: 12, order: 4 }}
              md={{ size: 12, order: 4 }}
              lg={{ size: 5, order: 2 }}
              className='pt-2 pt-lg-0'
            >
              <Autosuggest
                suggestions={suggestions}
                onSuggestionsFetchRequested={onSuggestionsFetchRequested}
                onSuggestionsClearRequested={onSuggestionsClearRequested}
                getSuggestionValue={this.getSuggestionValue}
                renderSuggestion={this.renderSuggestion}
                inputProps={inputProps}
                onSuggestionSelected={(_, item) => {
                  history.push(`/product/${item.suggestion.slug}`);
                }}
              />
            </Col>
            <Col
              xs={{ size: 12, order: 2 }}
              sm={{ size: 12, order: 2 }}
              md={{ size: 4, order: 1 }}
              lg={{ size: 5, order: 3 }}
              className='desktop-hidden'
            >
              <div className='header-links'>
                <Button
                  borderless
                  variant='empty'
                  ariaLabel='open the menu'
                  icon={<BarsIcon />}
                  onClick={() => this.toggleMenu()}
                />
                <CartIcon cartItems={cartItems} onClick={toggleCart} />
              </div>
            </Col>
            <Col
              xs={{ size: 12, order: 2 }}
              sm={{ size: 12, order: 2 }}
              md={{ size: 9, order: 1 }}
              lg={{ size: 4, order: 3 }}
              // className='px-0'
            >
              <Navbar color='light' light expand='md' className='mt-1 mt-md-0'>
                <CartIcon
                  className='d-none d-md-block'
                  cartItems={cartItems}
                  onClick={toggleCart}
                />
                <Nav navbar>
                  {brands && brands.length > 0 && (
                    <Dropdown
                      nav
                      inNavbar
                      toggle={() => this.toggleBrand()}
                      isOpen={isBrandOpen}
                    >
                      <DropdownToggle nav>
                        Brands
                        <span className='fa fa-chevron-down dropdown-caret'></span>
                      </DropdownToggle>
                      <DropdownMenu right className='nav-brand-dropdown'>
                        <div className='mini-brand'>
                          <MiniBrand
                            brands={brands}
                            toggleBrand={() => this.toggleBrand()}
                          />
                        </div>
                      </DropdownMenu>
                    </Dropdown>
                  )}
                  <NavItem>
                    <NavLink
                      tag={ActiveLink}
                      to='/shop'
                      activeClassName='active'
                    >
                      Shop
                    </NavLink>
                  </NavItem>
                  {authenticated ? (
                    <UncontrolledDropdown nav inNavbar>
                      <DropdownToggle nav>
                        {user.firstName ? user.firstName : 'Welcome'}
                        <span className='fa fa-chevron-down dropdown-caret'></span>
                      </DropdownToggle>
                      <DropdownMenu right>
                        <DropdownItem
                          onClick={() => history.push('/dashboard')}
                        >
                          Dashboard
                        </DropdownItem>
                        <DropdownItem onClick={signOut}>Sign Out</DropdownItem>
                      </DropdownMenu>
                    </UncontrolledDropdown>
                  ) : (
                    <UncontrolledDropdown nav inNavbar>
                      <DropdownToggle nav>
                        Welcome!
                        <span className='fa fa-chevron-down dropdown-caret'></span>
                      </DropdownToggle>
                      <DropdownMenu right>
                        <DropdownItem onClick={() => history.push('/login')}>
                          Login
                        </DropdownItem>
                        <DropdownItem onClick={() => history.push('/register')}>
                          Sign Up
                        </DropdownItem>
                      </DropdownMenu>
                    </UncontrolledDropdown>
                  )}
                </Nav>
              </Navbar>
            </Col>
          </Row>
        </Container>

        {/* hidden cart drawer */}
        <div
          className={isCartOpen ? 'mini-cart-open' : 'hidden-mini-cart'}
          aria-hidden={`${isCartOpen ? false : true}`}
        >
          <div className='mini-cart'>
            <Cart />
          </div>
          <div
            className={
              isCartOpen ? 'drawer-backdrop dark-overflow' : 'drawer-backdrop'
            }
            onClick={toggleCart}
          />
        </div>

        {/* hidden menu drawer */}
        <div
          className={isMenuOpen ? 'mini-menu-open' : 'hidden-mini-menu'}
          aria-hidden={`${isMenuOpen ? false : true}`}
        >
          <div className='mini-menu'>
            <Menu />
          </div>
          <div
            className={
              isMenuOpen ? 'drawer-backdrop dark-overflow' : 'drawer-backdrop'
            }
            onClick={toggleMenu}
          />
        </div>
      </header>
    );
  }
}

const mapStateToProps = state => {
  return {
    isMenuOpen: state.navigation.isMenuOpen,
    isCartOpen: state.navigation.isCartOpen,
    isBrandOpen: state.navigation.isBrandOpen,
    cartItems: state.cart.cartItems,
    brands: state.brand.storeBrands,
    categories: state.category.storeCategories,
    authenticated: state.authentication.authenticated,
    user: state.account.user,
    searchValue: state.navigation.searchValue,
    suggestions: state.navigation.searchSuggestions
  };
};

export default connect(mapStateToProps, actions)(withRouter(Navigation));
</file>
<file name="./client/app/containers/Navigation/actions.js" format="js">
/*
 *
 * Navigation actions
 *
 */

import axios from 'axios';
import handleError from '../../utils/error';
import {
  TOGGLE_MENU,
  TOGGLE_CART,
  TOGGLE_BRAND,
  SEARCH_CHANGE,
  SUGGESTIONS_FETCH_REQUEST,
  SUGGESTIONS_CLEAR_REQUEST
} from './constants';
import { API_URL } from '../../constants';

export const toggleMenu = () => {
  return {
    type: TOGGLE_MENU
  };
};

export const toggleCart = () => {
  return {
    type: TOGGLE_CART
  };
};

export const toggleBrand = () => {
  return {
    type: TOGGLE_BRAND
  };
};

export const onSearch = v => {
  return {
    type: SEARCH_CHANGE,
    payload: v
  };
};

export const onSuggestionsFetchRequested = value => {
  const inputValue = value.value.trim().toLowerCase();

  return async (dispatch, getState) => {
    try {
      if (inputValue && inputValue.length % 3 === 0) {
        const response = await axios.get(
          `${API_URL}/product/list/search/${inputValue}`
        );
        dispatch({
          type: SUGGESTIONS_FETCH_REQUEST,
          payload: response.data.products
        });
      }
    } catch (error) {
      handleError(error, dispatch);
    }
  };
};

export const onSuggestionsClearRequested = () => {
  return {
    type: SUGGESTIONS_CLEAR_REQUEST,
    payload: []
  };
};
</file>
<file name="./client/app/containers/ProductPage/index.js" format="js">
/**
 *
 * ProductPage
 *
 */

import React from 'react';
import { connect } from 'react-redux';
import { Row, Col } from 'reactstrap';
import { Link } from 'react-router-dom';

import actions from '../../actions';

import Input from '../../components/Common/Input';
import Button from '../../components/Common/Button';
import LoadingIndicator from '../../components/Common/LoadingIndicator';
import NotFound from '../../components/Common/NotFound';
import { BagIcon } from '../../components/Common/Icon';
import ProductReviews from '../../components/Store/ProductReviews';
import SocialShare from '../../components/Store/SocialShare';

class ProductPage extends React.PureComponent {
  componentDidMount() {
    const slug = this.props.match.params.slug;
    this.props.fetchStoreProduct(slug);
    this.props.fetchProductReviews(slug);
    document.body.classList.add('product-page');
  }

  componentDidUpdate(prevProps) {
    if (this.props.match.params.slug !== prevProps.match.params.slug) {
      const slug = this.props.match.params.slug;
      this.props.fetchStoreProduct(slug);
    }
  }

  componentWillUnmount() {
    document.body.classList.remove('product-page');
  }

  render() {
    const {
      isLoading,
      product,
      productShopData,
      shopFormErrors,
      itemInCart,
      productShopChange,
      handleAddToCart,
      handleRemoveFromCart,
      addProductReview,
      reviewsSummary,
      reviews,
      reviewFormData,
      reviewChange,
      reviewFormErrors
    } = this.props;

    return (
      <div className='product-shop'>
        {isLoading ? (
          <LoadingIndicator />
        ) : Object.keys(product).length > 0 ? (
          <>
            <Row className='flex-row'>
              <Col xs='12' md='5' lg='5' className='mb-3 px-3 px-md-2'>
                <div className='position-relative'>
                  <img
                    className='item-image'
                    src={`${
                      product.imageUrl
                        ? product.imageUrl
                        : '/images/placeholder-image.png'
                    }`}
                  />
                  {product.inventory <= 0 && !shopFormErrors['quantity'] ? (
                    <p className='stock out-of-stock'>Out of stock</p>
                  ) : (
                    <p className='stock in-stock'>In stock</p>
                  )}
                </div>
              </Col>
              <Col xs='12' md='7' lg='7' className='mb-3 px-3 px-md-2'>
                <div className='product-container'>
                  <div className='item-box'>
                    <div className='item-details'>
                      <h1 className='item-name one-line-ellipsis'>
                        {product.name}
                      </h1>
                      <p className='sku'>{product.sku}</p>
                      <hr />
                      {product.brand && (
                        <p className='by'>
                          see more from{' '}
                          <Link
                            to={`/shop/brand/${product.brand.slug}`}
                            className='default-link'
                          >
                            {product.brand.name}
                          </Link>
                        </p>
                      )}
                      <p className='item-desc'>{product.description}</p>
                      <p className='price'>${product.price}</p>
                    </div>
                    <div className='item-customize'>
                      <Input
                        type={'number'}
                        error={shopFormErrors['quantity']}
                        label={'Quantity'}
                        name={'quantity'}
                        decimals={false}
                        min={1}
                        max={product.inventory}
                        placeholder={'Product Quantity'}
                        disabled={
                          product.inventory <= 0 && !shopFormErrors['quantity']
                        }
                        value={productShopData.quantity}
                        onInputChange={(name, value) => {
                          productShopChange(name, value);
                        }}
                      />
                    </div>
                    <div className='my-4 item-share'>
                      <SocialShare product={product} />
                    </div>
                    <div className='item-actions'>
                      {itemInCart ? (
                        <Button
                          variant='primary'
                          disabled={
                            product.inventory <= 0 &&
                            !shopFormErrors['quantity']
                          }
                          text='Remove From Bag'
                          className='bag-btn'
                          icon={<BagIcon />}
                          onClick={() => handleRemoveFromCart(product)}
                        />
                      ) : (
                        <Button
                          variant='primary'
                          disabled={
                            product.quantity <= 0 && !shopFormErrors['quantity']
                          }
                          text='Add To Bag'
                          className='bag-btn'
                          icon={<BagIcon />}
                          onClick={() => handleAddToCart(product)}
                        />
                      )}
                    </div>
                  </div>
                </div>
              </Col>
            </Row>
            <ProductReviews
              reviewFormData={reviewFormData}
              reviewFormErrors={reviewFormErrors}
              reviews={reviews}
              reviewsSummary={reviewsSummary}
              reviewChange={reviewChange}
              addReview={addProductReview}
            />
          </>
        ) : (
          <NotFound message='No product found.' />
        )}
      </div>
    );
  }
}

const mapStateToProps = state => {
  const itemInCart = state.cart.cartItems.find(
    item => item._id === state.product.storeProduct._id
  )
    ? true
    : false;

  return {
    product: state.product.storeProduct,
    productShopData: state.product.productShopData,
    shopFormErrors: state.product.shopFormErrors,
    isLoading: state.product.isLoading,
    reviews: state.review.productReviews,
    reviewsSummary: state.review.reviewsSummary,
    reviewFormData: state.review.reviewFormData,
    reviewFormErrors: state.review.reviewFormErrors,
    itemInCart
  };
};

export default connect(mapStateToProps, actions)(ProductPage);
</file>
<file name="./client/app/containers/Application/constants.js" format="js">
/*
 *
 * Application constants
 *
 */

export const DEFAULT_ACTION = 'src/Application/DEFAULT_ACTION';
</file>
<file name="./client/app/containers/Application/reducer.js" format="js">
/*
 *
 * Application reducer
 *
 */

import { DEFAULT_ACTION } from './constants';

const initialState = {};

const applicationReducer = (state = initialState, action) => {
  switch (action.type) {
    case DEFAULT_ACTION:
      return state;
    default:
      return state;
  }
};

export default applicationReducer;
</file>
<file name="./client/app/containers/Application/index.js" format="js">
/**
 *
 * Application
 *
 */

import React from 'react';

import { connect } from 'react-redux';
import { Switch, Route } from 'react-router-dom';
import { Container } from 'reactstrap';

import actions from '../../actions';

// routes
import Login from '../Login';
import Signup from '../Signup';
import MerchantSignup from '../MerchantSignup';
import HomePage from '../Homepage';
import Dashboard from '../Dashboard';
import Support from '../Support';
import Navigation from '../Navigation';
import Authentication from '../Authentication';
import Notification from '../Notification';
import ForgotPassword from '../ForgotPassword';
import ResetPassword from '../ResetPassword';
import Shop from '../Shop';
import BrandsPage from '../BrandsPage';
import ProductPage from '../ProductPage';
import Sell from '../Sell';
import Contact from '../Contact';
import OrderSuccess from '../OrderSuccess';
import OrderPage from '../OrderPage';
import AuthSuccess from '../AuthSuccess';

import Footer from '../../components/Common/Footer';
import Page404 from '../../components/Common/Page404';
import { CART_ITEMS } from '../../constants';

class Application extends React.PureComponent {
  constructor(props) {
    super(props);
    this.handleStorage = this.handleStorage.bind(this);
  }
  componentDidMount() {
    const token = localStorage.getItem('token');

    if (token) {
      this.props.fetchProfile();
    }

    this.props.handleCart();

    document.addEventListener('keydown', this.handleTabbing);
    document.addEventListener('mousedown', this.handleMouseDown);
    window.addEventListener('storage', this.handleStorage);
  }

  handleStorage(e) {
    if (e.key === CART_ITEMS) {
      this.props.handleCart();
    }
  }

  handleTabbing(e) {
    if (e.keyCode === 9) {
      document.body.classList.add('user-is-tabbing');
    }
  }

  handleMouseDown() {
    document.body.classList.remove('user-is-tabbing');
  }

  render() {
    return (
      <div className='application'>
        <Notification />
        <Navigation />
        <main className='main'>
          <Container>
            <div className='wrapper'>
              <Switch>
                <Route exact path='/' component={HomePage} />
                <Route path='/shop' component={Shop} />
                <Route path='/sell' component={Sell} />
                <Route path='/contact' component={Contact} />
                <Route path='/brands' component={BrandsPage} />
                <Route path='/product/:slug' component={ProductPage} />
                <Route path='/order/success/:id' component={OrderSuccess} />
                <Route path='/order/:id' component={OrderPage} />
                <Route path='/login' component={Login} />
                <Route path='/register' component={Signup} />
                <Route
                  path='/merchant-signup/:token'
                  component={MerchantSignup}
                />
                <Route path='/forgot-password' component={ForgotPassword} />
                <Route
                  path='/reset-password/:token'
                  component={ResetPassword}
                />
                <Route path='/auth/success' component={AuthSuccess} />
                <Route path='/support' component={Authentication(Support)} />
                <Route
                  path='/dashboard'
                  component={Authentication(Dashboard)}
                />
                <Route path='/404' component={Page404} />
                <Route path='*' component={Page404} />
              </Switch>
            </div>
          </Container>
        </main>
        <Footer />
      </div>
    );
  }
}

const mapStateToProps = state => {
  return {
    authenticated: state.authentication.authenticated,
    products: state.product.storeProducts
  };
};

export default connect(mapStateToProps, actions)(Application);
</file>
<file name="./client/app/containers/Application/actions.js" format="js">
/*
 *
 * Application actions
 *
 */

import { DEFAULT_ACTION } from './constants';

export const defaultAction = () => {
  return {
    type: DEFAULT_ACTION
  };
};
</file>
<file name="./client/app/containers/BrandsShop/index.js" format="js">
/**
 *
 * BrandsShop
 *
 */

import React from 'react';
import { connect } from 'react-redux';

import actions from '../../actions';

import ProductList from '../../components/Store/ProductList';
import NotFound from '../../components/Common/NotFound';
import LoadingIndicator from '../../components/Common/LoadingIndicator';

class BrandsShop extends React.PureComponent {
  componentDidMount() {
    const slug = this.props.match.params.slug;
    this.props.fetchBrandProducts(slug);
  }

  componentDidUpdate(prevProps) {
    if (this.props.match.params.slug !== prevProps.match.params.slug) {
      const slug = this.props.match.params.slug;
      this.props.fetchBrandProducts(slug);
    }
  }

  render() {
    const { products, isLoading, authenticated, updateWishlist } = this.props;

    return (
      <div className='brands-shop'>
        {isLoading ? (
          <LoadingIndicator />
        ) : products.length > 0 ? (
          <ProductList
            products={products}
            authenticated={authenticated}
            updateWishlist={updateWishlist}
          />
        ) : (
          <NotFound message='No products found.' />
        )}
      </div>
    );
  }
}

const mapStateToProps = state => {
  return {
    products: state.product.storeProducts,
    isLoading: state.product.isLoading,
    authenticated: state.authentication.authenticated
  };
};

export default connect(mapStateToProps, actions)(BrandsShop);
</file>
<file name="./client/app/containers/BrandsPage/index.js" format="js">
/**
 *
 * BrandsPage
 *
 */

import React from 'react';

import { connect } from 'react-redux';

import actions from '../../actions';

import BrandList from '../../components/Store/BrandList';

class BrandsPage extends React.PureComponent {
  componentDidMount() {
    this.props.fetchStoreBrands();
  }

  render() {
    const { brands } = this.props;

    return (
      <div className='brands-page'>
        <BrandList brands={brands} />
      </div>
    );
  }
}

const mapStateToProps = state => {
  return {
    brands: state.brand.storeBrands
  };
};

export default connect(mapStateToProps, actions)(BrandsPage);
</file>
<file name="./client/app/containers/Users/constants.js" format="js">
/*
 *
 * Users constants
 *
 */

export const FETCH_USERS = 'src/Users/FETCH_USERS';
export const FETCH_SEARCHED_USERS = 'src/Users/FETCH_SEARCHED_USERS';
export const SET_ADVANCED_FILTERS = 'src/Users/SET_ADVANCED_FILTERS';
export const SET_USERS_LOADING = 'src/Users/SET_USERS_LOADING';
</file>
<file name="./client/app/containers/Users/reducer.js" format="js">
/*
 *
 * Users reducer
 *
 */

import {
  FETCH_USERS,
  FETCH_SEARCHED_USERS,
  SET_ADVANCED_FILTERS,
  SET_USERS_LOADING
} from './constants';

const initialState = {
  users: [],
  searchedUsers: [],
  advancedFilters: {
    totalPages: 1,
    currentPage: 1,
    count: 0
  },
  isLoading: false
};

const usersReducer = (state = initialState, action) => {
  switch (action.type) {
    case FETCH_USERS:
      return {
        ...state,
        users: action.payload
      };
    case FETCH_SEARCHED_USERS:
      return {
        ...state,
        searchedUsers: action.payload
      };
    case SET_ADVANCED_FILTERS:
      return {
        ...state,
        advancedFilters: {
          ...state.advancedFilters,
          ...action.payload
        }
      };
    case SET_USERS_LOADING:
      return {
        ...state,
        isLoading: action.payload
      };
    default:
      return state;
  }
};

export default usersReducer;
</file>
<file name="./client/app/containers/Users/index.js" format="js">
/*
 *
 * Users
 *
 */

import React from 'react';

import { connect } from 'react-redux';

import actions from '../../actions';

import UserList from '../../components/Manager/UserList';
import UserSearch from '../../components/Manager/UserSearch';
import SubPage from '../../components/Manager/SubPage';
import SearchResultMeta from '../../components/Manager/SearchResultMeta';
import NotFound from '../../components/Common/NotFound';
import LoadingIndicator from '../../components/Common/LoadingIndicator';
import Pagination from '../../components/Common/Pagination';

class Users extends React.PureComponent {
  constructor(props) {
    super(props);

    this.state = {
      search: ''
    };
  }

  componentDidMount() {
    this.props.fetchUsers();
  }

  handleUserSearch = e => {
    if (e.value.length >= 2) {
      this.props.searchUsers({ name: 'user', value: e.value });
      this.setState({
        search: e.value
      });
    } else {
      this.setState({
        search: ''
      });
    }
  };

  handleOnPagination = (n, v) => {
    this.props.fetchUsers(v);
  };

  render() {
    const { users, isLoading, searchedUsers, searchUsers, advancedFilters } =
      this.props;

    const { search } = this.state;
    const isSearch = search.length > 0;
    const filteredUsers = search ? searchedUsers : users;
    const displayPagination = advancedFilters.totalPages > 1;
    const displayUsers = filteredUsers && filteredUsers.length > 0;

    return (
      <div className='users-dashboard'>
        <SubPage title='Users' />
        <UserSearch
          onSearch={this.handleUserSearch}
          onSearchSubmit={searchUsers}
        />
        {isLoading && <LoadingIndicator />}
        {displayUsers && (
          <>
            {!isSearch && displayPagination && (
              <Pagination
                totalPages={advancedFilters.totalPages}
                onPagination={this.handleOnPagination}
              />
            )}
            <SearchResultMeta
              label='users'
              count={isSearch ? filteredUsers.length : advancedFilters.count}
            />
            <UserList users={filteredUsers} />
          </>
        )}
        {!isLoading && !displayUsers && <NotFound message='No users found.' />}
      </div>
    );
  }
}

const mapStateToProps = state => {
  return {
    users: state.users.users,
    searchedUsers: state.users.searchedUsers,
    advancedFilters: state.users.advancedFilters,
    isLoading: state.users.isLoading
  };
};

export default connect(mapStateToProps, actions)(Users);
</file>
<file name="./client/app/containers/Users/actions.js" format="js">
/*
 *
 * Users actions
 *
 */

import axios from 'axios';

import {
  FETCH_USERS,
  FETCH_SEARCHED_USERS,
  SET_ADVANCED_FILTERS,
  SET_USERS_LOADING
} from './constants';

import handleError from '../../utils/error';
import { API_URL } from '../../constants';

export const setUserLoading = value => {
  return {
    type: SET_USERS_LOADING,
    payload: value
  };
};

export const fetchUsers = page => {
  return async (dispatch, getState) => {
    try {
      dispatch(setUserLoading(true));
      const response = await axios.get(`${API_URL}/user`, {
        params: {
          page: page ?? 1,
          limit: 20
        }
      });

      const { users, totalPages, currentPage, count } = response.data;

      dispatch({
        type: FETCH_USERS,
        payload: users
      });
      dispatch({
        type: SET_ADVANCED_FILTERS,
        payload: { totalPages, currentPage, count }
      });
    } catch (error) {
      handleError(error, dispatch);
    } finally {
      dispatch(setUserLoading(false));
    }
  };
};

export const searchUsers = filter => {
  return async (dispatch, getState) => {
    try {
      dispatch(setUserLoading(true));

      const response = await axios.get(`${API_URL}/user/search`, {
        params: {
          search: filter.value
        }
      });

      dispatch({ type: FETCH_SEARCHED_USERS, payload: response.data.users });
    } catch (error) {
      handleError(error, dispatch);
    } finally {
      dispatch(setUserLoading(false));
    }
  };
};
</file>
<file name="./client/app/containers/WishList/constants.js" format="js">
/*
 *
 * WishList constants
 *
 */

export const FETCH_WISHLIST = 'src/WishList/FETCH_WISHLIST';
export const SET_WISHLIST_LOADING = 'src/WishList/SET_WISHLIST_LOADING';
</file>
<file name="./client/app/containers/WishList/reducer.js" format="js">
/*
 *
 * WishList reducer
 *
 */

import { FETCH_WISHLIST, SET_WISHLIST_LOADING } from './constants';

const initialState = {
  wishlist: [],
  isLoading: false,
  wishlistForm: {}
};

const wishListReducer = (state = initialState, action) => {
  switch (action.type) {
    case FETCH_WISHLIST:
      return {
        ...state,
        wishlist: action.payload
      };
    case SET_WISHLIST_LOADING:
      return {
        ...state,
        isLoading: action.payload
      };
    default:
      return state;
  }
};

export default wishListReducer;
</file>
<file name="./client/app/containers/WishList/index.js" format="js">
/*
 *
 * WishList
 *
 */

import React from 'react';

import { connect } from 'react-redux';

import actions from '../../actions';

import SubPage from '../../components/Manager/SubPage';
import WishList from '../../components/Manager/WishList';
import NotFound from '../../components/Common/NotFound';
import LoadingIndicator from '../../components/Common/LoadingIndicator';

class Wishlist extends React.PureComponent {
  componentDidMount() {
    this.props.fetchWishlist();
  }

  render() {
    const { wishlist, isLoading, updateWishlist } = this.props;

    const displayWishlist = wishlist.length > 0;

    return (
      <div className='wishlist-dashboard'>
        <SubPage title={'Your Wishlist'} isMenuOpen={null}>
          {isLoading && <LoadingIndicator />}
          {displayWishlist && (
            <WishList wishlist={wishlist} updateWishlist={updateWishlist} />
          )}
          {!isLoading && !displayWishlist && (
            <NotFound message='You have no items in your wishlist yet.' />
          )}
        </SubPage>
      </div>
    );
  }
}

const mapStateToProps = state => {
  return {
    wishlist: state.wishlist.wishlist,
    isLoading: state.wishlist.isLoading
  };
};

export default connect(mapStateToProps, actions)(Wishlist);
</file>
<file name="./client/app/containers/WishList/actions.js" format="js">
/*
 *
 * WishList actions
 *
 */

import { success, warning } from 'react-notification-system-redux';
import axios from 'axios';

import { FETCH_WISHLIST, SET_WISHLIST_LOADING } from './constants';
import handleError from '../../utils/error';
import { API_URL } from '../../constants';

export const updateWishlist = (isLiked, productId) => {
  return async (dispatch, getState) => {
    try {
      if (getState().authentication.authenticated === true) {
        const response = await axios.post(`${API_URL}/wishlist`, {
          isLiked,
          product: productId
        });

        const successfulOptions = {
          title: `${response.data.message}`,
          position: 'tr',
          autoDismiss: 1
        };

        if (response.data.success === true) {
          dispatch(success(successfulOptions));
          dispatch(fetchWishlist());
        }
      } else {
        const retryOptions = {
          title: `Please login to wishlist a product`,
          position: 'tr',
          autoDismiss: 1
        };
        dispatch(warning(retryOptions));
      }
    } catch (error) {
      handleError(error, dispatch);
    }
  };
};

// fetch wishlist api
export const fetchWishlist = () => {
  return async (dispatch, getState) => {
    try {
      dispatch({ type: SET_WISHLIST_LOADING, payload: true });

      const response = await axios.get(`${API_URL}/wishlist`);

      dispatch({ type: FETCH_WISHLIST, payload: response.data.wishlist });
    } catch (error) {
      handleError(error, dispatch);
    } finally {
      dispatch({ type: SET_WISHLIST_LOADING, payload: false });
    }
  };
};
</file>
<file name="./client/app/containers/Signup/constants.js" format="js">
/*
 *
 * Signup constants
 *
 */

export const SIGNUP_CHANGE = 'src/Signup/SIGNUP_CHANGE';
export const SIGNUP_RESET = 'src/Signup/SIGNUP_RESET';
export const SET_SIGNUP_LOADING = 'src/Signup/SET_SIGNUP_LOADING';
export const SET_SIGNUP_SUBMITTING = 'src/Signup/SET_SIGNUP_SUBMITTING';
export const SET_SIGNUP_FORM_ERRORS = 'src/Signup/SET_SIGNUP_FORM_ERRORS';
export const SUBSCRIBE_CHANGE = 'src/Signup/SUBSCRIBE_CHANGE';
</file>
<file name="./client/app/containers/Signup/reducer.js" format="js">
/*
 *
 * Signup reducer
 *
 */

import {
  SIGNUP_CHANGE,
  SIGNUP_RESET,
  SET_SIGNUP_LOADING,
  SET_SIGNUP_SUBMITTING,
  SUBSCRIBE_CHANGE,
  SET_SIGNUP_FORM_ERRORS
} from './constants';

const initialState = {
  signupFormData: {
    email: '',
    firstName: '',
    lastName: '',
    password: ''
  },
  formErrors: {},
  isSubmitting: false,
  isLoading: false,
  isSubscribed: false
};

const signupReducer = (state = initialState, action) => {
  switch (action.type) {
    case SIGNUP_CHANGE:
      return {
        ...state,
        signupFormData: { ...state.signupFormData, ...action.payload }
      };
    case SUBSCRIBE_CHANGE:
      return {
        ...state,
        isSubscribed: !state.isSubscribed
      };
    case SET_SIGNUP_FORM_ERRORS:
      return {
        ...state,
        formErrors: action.payload
      };
    case SET_SIGNUP_LOADING:
      return {
        ...state,
        isLoading: action.payload
      };
    case SET_SIGNUP_SUBMITTING:
      return {
        ...state,
        isSubmitting: action.payload
      };
    case SIGNUP_RESET:
      return {
        ...state,
        signupFormData: {
          email: '',
          firstName: '',
          lastName: '',
          password: ''
        },
        formErrors: {},
        isLoading: false
      };
    default:
      return state;
  }
};

export default signupReducer;
</file>
<file name="./client/app/containers/Signup/index.js" format="js">
/*
 *
 * Signup
 *
 */

import React from 'react';

import { connect } from 'react-redux';
import { Row, Col } from 'reactstrap';
import { Redirect, Link } from 'react-router-dom';

import actions from '../../actions';

import Input from '../../components/Common/Input';
import Button from '../../components/Common/Button';
import Checkbox from '../../components/Common/Checkbox';
import LoadingIndicator from '../../components/Common/LoadingIndicator';
import SignupProvider from '../../components/Common/SignupProvider';

class Signup extends React.PureComponent {
  render() {
    const {
      authenticated,
      signupFormData,
      formErrors,
      isLoading,
      isSubmitting,
      isSubscribed,
      signupChange,
      signUp,
      subscribeChange
    } = this.props;

    if (authenticated) return <Redirect to='/dashboard' />;

    const handleSubmit = event => {
      event.preventDefault();
      signUp();
    };

    return (
      <div className='signup-form'>
        {isLoading && <LoadingIndicator />}
        <h2>Sign Up</h2>
        <hr />
        <form onSubmit={handleSubmit} noValidate>
          <Row>
            <Col
              xs={{ size: 12, order: 2 }}
              md={{ size: '6', order: 1 }}
              className='p-0'
            >
              <Col xs='12' md='12'>
                <Input
                  type={'text'}
                  error={formErrors['email']}
                  label={'Email Address'}
                  name={'email'}
                  placeholder={'Please Enter Your Email'}
                  value={signupFormData.email}
                  onInputChange={(name, value) => {
                    signupChange(name, value);
                  }}
                />
              </Col>
              <Col xs='12' md='12'>
                <Input
                  type={'text'}
                  error={formErrors['firstName']}
                  label={'First Name'}
                  name={'firstName'}
                  placeholder={'Please Enter Your First Name'}
                  value={signupFormData.firstName}
                  onInputChange={(name, value) => {
                    signupChange(name, value);
                  }}
                />
              </Col>
              <Col xs='12' md='12'>
                <Input
                  type={'text'}
                  error={formErrors['lastName']}
                  label={'Last Name'}
                  name={'lastName'}
                  placeholder={'Please Enter Your Last Name'}
                  value={signupFormData.lastName}
                  onInputChange={(name, value) => {
                    signupChange(name, value);
                  }}
                />
              </Col>
              <Col xs='12' md='12'>
                <Input
                  type={'password'}
                  label={'Password'}
                  error={formErrors['password']}
                  name={'password'}
                  placeholder={'Please Enter Your Password'}
                  value={signupFormData.password}
                  onInputChange={(name, value) => {
                    signupChange(name, value);
                  }}
                />
              </Col>
            </Col>
            <Col
              xs={{ size: 12, order: 1 }}
              md={{ size: '6', order: 2 }}
              className='mb-2 mb-md-0'
            >
              <SignupProvider />
            </Col>
          </Row>
          <hr />
          <Checkbox
            id={'subscribe'}
            label={'Subscribe to newsletter'}
            checked={isSubscribed}
            onChange={subscribeChange}
          />
          <div className='d-flex flex-column flex-md-row align-items-md-center justify-content-between'>
            <Button
              type='submit'
              variant='primary'
              text='Sign Up'
              disabled={isSubmitting}
            />
            <Link className='mt-3 mt-md-0 redirect-link' to={'/login'}>
              Back to login
            </Link>
          </div>
        </form>
      </div>
    );
  }
}

const mapStateToProps = state => {
  return {
    authenticated: state.authentication.authenticated,
    signupFormData: state.signup.signupFormData,
    formErrors: state.signup.formErrors,
    isLoading: state.signup.isLoading,
    isSubmitting: state.signup.isSubmitting,
    isSubscribed: state.signup.isSubscribed
  };
};

export default connect(mapStateToProps, actions)(Signup);
</file>
<file name="./client/app/containers/Signup/actions.js" format="js">
/*
 *
 * Signup actions
 *
 */

import { success } from 'react-notification-system-redux';
import axios from 'axios';

import {
  SIGNUP_CHANGE,
  SIGNUP_RESET,
  SET_SIGNUP_LOADING,
  SET_SIGNUP_SUBMITTING,
  SUBSCRIBE_CHANGE,
  SET_SIGNUP_FORM_ERRORS
} from './constants';

import { setAuth } from '../Authentication/actions';
import setToken from '../../utils/token';
import handleError from '../../utils/error';
import { allFieldsValidation } from '../../utils/validation';
import { API_URL } from '../../constants';

export const signupChange = (name, value) => {
  let formData = {};
  formData[name] = value;

  return {
    type: SIGNUP_CHANGE,
    payload: formData
  };
};

export const subscribeChange = () => {
  return {
    type: SUBSCRIBE_CHANGE
  };
};

export const signUp = () => {
  return async (dispatch, getState) => {
    try {
      const rules = {
        email: 'required|email',
        password: 'required|min:6',
        firstName: 'required',
        lastName: 'required'
      };

      const newUser = getState().signup.signupFormData;
      const isSubscribed = getState().signup.isSubscribed;

      const { isValid, errors } = allFieldsValidation(newUser, rules, {
        'required.email': 'Email is required.',
        'required.password': 'Password is required.',
        'required.firstName': 'First Name is required.',
        'required.lastName': 'Last Name is required.'
      });

      if (!isValid) {
        return dispatch({ type: SET_SIGNUP_FORM_ERRORS, payload: errors });
      }

      dispatch({ type: SET_SIGNUP_SUBMITTING, payload: true });
      dispatch({ type: SET_SIGNUP_LOADING, payload: true });

      const user = {
        isSubscribed,
        ...newUser
      };

      const response = await axios.post(`${API_URL}/auth/register`, user);

      const successfulOptions = {
        title: `You have signed up successfully! You will be receiving an email as well. Thank you!`,
        position: 'tr',
        autoDismiss: 1
      };

      localStorage.setItem('token', response.data.token);

      setToken(response.data.token);

      dispatch(setAuth());
      dispatch(success(successfulOptions));
      dispatch({ type: SIGNUP_RESET });
    } catch (error) {
      const title = `Please try to signup again!`;
      handleError(error, dispatch, title);
    } finally {
      dispatch({ type: SET_SIGNUP_SUBMITTING, payload: false });
      dispatch({ type: SET_SIGNUP_LOADING, payload: false });
    }
  };
};
</file>
<file name="./client/app/containers/AuthSuccess/index.js" format="js">
/**
 *
 * AuthSuccess
 *
 */

import React from 'react';

import { connect } from 'react-redux';
import { Redirect } from 'react-router-dom';

import actions from '../../actions';
import setToken from '../../utils/token';
import LoadingIndicator from '../../components/Common/LoadingIndicator';

class AuthSuccess extends React.PureComponent {
  componentDidMount() {
    const tokenParam = this.props.location.search;
    const jwtCookie = tokenParam
      .slice(tokenParam.indexOf('=') + 1)
      .replace('%20', ' ');
    if (jwtCookie) {
      setToken(jwtCookie);
      localStorage.setItem('token', jwtCookie);
      this.props.setAuth();
    }
  }

  render() {
    const { authenticated } = this.props;

    if (authenticated) return <Redirect to='/dashboard' />;

    return <LoadingIndicator />;
  }
}

const mapStateToProps = state => {
  return {
    authenticated: state.authentication.authenticated
  };
};

export default connect(mapStateToProps, actions)(AuthSuccess);
</file>
<file name="./client/app/containers/Cart/constants.js" format="js">
/*
 *
 * Cart constants
 *
 */

export const HANDLE_CART = 'src/Cart/HANDLE_CART';
export const ADD_TO_CART = 'src/Cart/ADD_TO_CART';
export const REMOVE_FROM_CART = 'src/Cart/REMOVE_FROM_CART';
export const HANDLE_CART_TOTAL = 'src/Cart/HANDLE_CART_TOTAL';
export const SET_CART_ID = 'src/Cart/SET_CART_ID';
export const CLEAR_CART = 'src/Cart/CLEAR_CART';
</file>
<file name="./client/app/containers/Cart/reducer.js" format="js">
/*
 *
 * Cart reducer
 *
 */

import {
  HANDLE_CART,
  ADD_TO_CART,
  REMOVE_FROM_CART,
  HANDLE_CART_TOTAL,
  SET_CART_ID,
  CLEAR_CART
} from './constants';

const initialState = {
  cartItems: [],
  cartTotal: 0,
  cartId: ''
};

const cartReducer = (state = initialState, action) => {
  let newState;

  switch (action.type) {
    case ADD_TO_CART:
      newState = {
        ...state,
        cartItems: [...state.cartItems, action.payload]
      };

      return newState;
    case REMOVE_FROM_CART:
      let itemIndex = state.cartItems.findIndex(
        x => x._id == action.payload._id
      );

      newState = {
        ...state,
        cartItems: [
          ...state.cartItems.slice(0, itemIndex),
          ...state.cartItems.slice(itemIndex + 1)
        ]
      };

      return newState;
    case HANDLE_CART_TOTAL:
      newState = {
        ...state,
        cartTotal: action.payload
      };

      return newState;
    case HANDLE_CART:
      newState = {
        ...state,
        cartItems: action.payload.cartItems,
        cartTotal: action.payload.cartTotal,
        cartId: action.payload.cartId
      };
      return newState;
    case SET_CART_ID:
      newState = {
        ...state,
        cartId: action.payload
      };
      return newState;
    case CLEAR_CART:
      newState = {
        ...state,
        cartItems: [],
        cartTotal: 0,
        cartId: ''
      };
      return newState;

    default:
      return state;
  }
};

export default cartReducer;
</file>
<file name="./client/app/containers/Cart/index.js" format="js">
/*
 *
 * Cart
 *
 */

import React from 'react';
import { connect } from 'react-redux';

import actions from '../../actions';

import CartList from '../../components/Store/CartList';
import CartSummary from '../../components/Store/CartSummary';
import Checkout from '../../components/Store/Checkout';
import { BagIcon, CloseIcon } from '../../components/Common/Icon';
import Button from '../../components/Common/Button';

class Cart extends React.PureComponent {
  render() {
    const {
      isCartOpen,
      cartItems,
      cartTotal,
      toggleCart,
      handleShopping,
      handleCheckout,
      handleRemoveFromCart,
      placeOrder,
      authenticated
    } = this.props;

    return (
      <div className='cart'>
        <div className='cart-header'>
          {isCartOpen && (
            <Button
              borderless
              variant='empty'
              ariaLabel='close the cart'
              icon={<CloseIcon />}
              onClick={toggleCart}
            />
          )}
        </div>
        {cartItems.length > 0 ? (
          <div className='cart-body'>
            <CartList
              toggleCart={toggleCart}
              cartItems={cartItems}
              handleRemoveFromCart={handleRemoveFromCart}
            />
          </div>
        ) : (
          <div className='empty-cart'>
            <BagIcon />
            <p>Your shopping cart is empty</p>
          </div>
        )}
        {cartItems.length > 0 && (
          <div className='cart-checkout'>
            <CartSummary cartTotal={cartTotal} />
            <Checkout
              handleShopping={handleShopping}
              handleCheckout={handleCheckout}
              placeOrder={placeOrder}
              authenticated={authenticated}
            />
          </div>
        )}
      </div>
    );
  }
}

const mapStateToProps = state => {
  return {
    isCartOpen: state.navigation.isCartOpen,
    cartItems: state.cart.cartItems,
    cartTotal: state.cart.cartTotal,
    authenticated: state.authentication.authenticated
  };
};

export default connect(mapStateToProps, actions)(Cart);
</file>
<file name="./client/app/containers/Cart/actions.js" format="js">
/*
 *
 * Cart actions
 *
 */

import { push } from 'connected-react-router';
import { success } from 'react-notification-system-redux';
import axios from 'axios';

import {
  HANDLE_CART,
  ADD_TO_CART,
  REMOVE_FROM_CART,
  HANDLE_CART_TOTAL,
  SET_CART_ID,
  CLEAR_CART
} from './constants';

import {
  SET_PRODUCT_SHOP_FORM_ERRORS,
  RESET_PRODUCT_SHOP
} from '../Product/constants';

import { API_URL, CART_ID, CART_ITEMS, CART_TOTAL } from '../../constants';
import handleError from '../../utils/error';
import { allFieldsValidation } from '../../utils/validation';
import { toggleCart } from '../Navigation/actions';

// Handle Add To Cart
export const handleAddToCart = product => {
  return (dispatch, getState) => {
    product.quantity = Number(getState().product.productShopData.quantity);
    product.totalPrice = product.quantity * product.price;
    product.totalPrice = parseFloat(product.totalPrice.toFixed(2));
    const inventory = getState().product.storeProduct.inventory;

    const result = calculatePurchaseQuantity(inventory);

    const rules = {
      quantity: `min:1|max:${result}`
    };

    const { isValid, errors } = allFieldsValidation(product, rules, {
      'min.quantity': 'Quantity must be at least 1.',
      'max.quantity': `Quantity may not be greater than ${result}.`
    });

    if (!isValid) {
      return dispatch({ type: SET_PRODUCT_SHOP_FORM_ERRORS, payload: errors });
    }

    dispatch({
      type: RESET_PRODUCT_SHOP
    });

    dispatch({
      type: ADD_TO_CART,
      payload: product
    });

    const cartItems = JSON.parse(localStorage.getItem(CART_ITEMS));
    let newCartItems = [];
    if (cartItems) {
      newCartItems = [...cartItems, product];
    } else {
      newCartItems.push(product);
    }
    localStorage.setItem(CART_ITEMS, JSON.stringify(newCartItems));

    dispatch(calculateCartTotal());
    dispatch(toggleCart());
  };
};

// Handle Remove From Cart
export const handleRemoveFromCart = product => {
  return (dispatch, getState) => {
    const cartItems = JSON.parse(localStorage.getItem(CART_ITEMS));
    const newCartItems = cartItems.filter(item => item._id !== product._id);
    localStorage.setItem(CART_ITEMS, JSON.stringify(newCartItems));

    dispatch({
      type: REMOVE_FROM_CART,
      payload: product
    });
    dispatch(calculateCartTotal());
    // dispatch(toggleCart());
  };
};

export const calculateCartTotal = () => {
  return (dispatch, getState) => {
    const cartItems = getState().cart.cartItems;

    let total = 0;

    cartItems.map(item => {
      total += item.price * item.quantity;
    });

    total = parseFloat(total.toFixed(2));
    localStorage.setItem(CART_TOTAL, total);
    dispatch({
      type: HANDLE_CART_TOTAL,
      payload: total
    });
  };
};

// set cart store from local storage
export const handleCart = () => {
  const cart = {
    cartItems: JSON.parse(localStorage.getItem(CART_ITEMS)),
    cartTotal: localStorage.getItem(CART_TOTAL),
    cartId: localStorage.getItem(CART_ID)
  };

  return (dispatch, getState) => {
    if (cart.cartItems != undefined) {
      dispatch({
        type: HANDLE_CART,
        payload: cart
      });
      dispatch(calculateCartTotal());
    }
  };
};

export const handleCheckout = () => {
  return (dispatch, getState) => {
    const successfulOptions = {
      title: `Please Login to proceed to checkout`,
      position: 'tr',
      autoDismiss: 1
    };

    dispatch(toggleCart());
    dispatch(push('/login'));
    dispatch(success(successfulOptions));
  };
};

// Continue shopping use case
export const handleShopping = () => {
  return (dispatch, getState) => {
    dispatch(push('/shop'));
    dispatch(toggleCart());
  };
};

// create cart id api
export const getCartId = () => {
  return async (dispatch, getState) => {
    try {
      const cartId = localStorage.getItem(CART_ID);
      const cartItems = getState().cart.cartItems;
      const products = getCartItems(cartItems);

      // create cart id if there is no one
      if (!cartId) {
        const response = await axios.post(`${API_URL}/cart/add`, { products });

        dispatch(setCartId(response.data.cartId));
      }
    } catch (error) {
      handleError(error, dispatch);
    }
  };
};

export const setCartId = cartId => {
  return (dispatch, getState) => {
    localStorage.setItem(CART_ID, cartId);
    dispatch({
      type: SET_CART_ID,
      payload: cartId
    });
  };
};

export const clearCart = () => {
  return (dispatch, getState) => {
    localStorage.removeItem(CART_ITEMS);
    localStorage.removeItem(CART_TOTAL);
    localStorage.removeItem(CART_ID);

    dispatch({
      type: CLEAR_CART
    });
  };
};

const getCartItems = cartItems => {
  const newCartItems = [];
  cartItems.map(item => {
    const newItem = {};
    newItem.quantity = item.quantity;
    newItem.price = item.price;
    newItem.taxable = item.taxable;
    newItem.product = item._id;
    newCartItems.push(newItem);
  });

  return newCartItems;
};

const calculatePurchaseQuantity = inventory => {
  if (inventory <= 25) {
    return 1;
  } else if (inventory > 25 && inventory <= 100) {
    return 5;
  } else if (inventory > 100 && inventory < 500) {
    return 25;
  } else {
    return 50;
  }
};
</file>
<file name="./client/app/containers/MerchantSignup/index.js" format="js">
/*
 *
 * MerchantSignup
 *
 */

import React from 'react';

import { connect } from 'react-redux';
import { Row, Col } from 'reactstrap';

import actions from '../../actions';
import Input from '../../components/Common/Input';
import Button from '../../components/Common/Button';

class MerchantSignup extends React.PureComponent {
  componentDidMount() {
    const email = this.props.location.search.split('=')[1];
    this.props.merchantSignupChange('email', email);
  }

  render() {
    const {
      signupFormData,
      formErrors,
      merchantSignupChange,
      merchantSignUp
    } = this.props;

    const handleSubmit = event => {
      const token = this.props.match.params.token;
      event.preventDefault();

      merchantSignUp(token);
    };

    return (
      <div className='merchant-signup-form'>
        <form onSubmit={handleSubmit} noValidate>
          <Row>
            <Col xs={{ size: 12 }} md={{ size: 6, offset: 3 }} className='p-0'>
              <Col xs='12' md='12'>
                <h2 className='text-center'>Complete Sign Up</h2>
                <hr />
              </Col>

              <Col xs='12' md='12'>
                <Input
                  type={'text'}
                  error={formErrors['email']}
                  label={'Email Address'}
                  name={'email'}
                  placeholder={'Please Enter Your Email'}
                  value={signupFormData.email}
                  onInputChange={(name, value) => {
                    merchantSignupChange(name, value);
                  }}
                />
              </Col>
              <Col xs='12' md='12'>
                <Input
                  type={'text'}
                  error={formErrors['firstName']}
                  label={'First Name'}
                  name={'firstName'}
                  placeholder={'Please Enter Your First Name'}
                  value={signupFormData.firstName}
                  onInputChange={(name, value) => {
                    merchantSignupChange(name, value);
                  }}
                />
              </Col>
              <Col xs='12' md='12'>
                <Input
                  type={'text'}
                  error={formErrors['lastName']}
                  label={'Last Name'}
                  name={'lastName'}
                  placeholder={'Please Enter Your Last Name'}
                  value={signupFormData.lastName}
                  onInputChange={(name, value) => {
                    merchantSignupChange(name, value);
                  }}
                />
              </Col>
              <Col xs='12' md='12'>
                <Input
                  type={'password'}
                  label={'Password'}
                  error={formErrors['password']}
                  name={'password'}
                  placeholder={'Please Enter Your Password'}
                  value={signupFormData.password}
                  onInputChange={(name, value) => {
                    merchantSignupChange(name, value);
                  }}
                />
              </Col>
              <Col xs='12' md='12'>
                <Button
                  className='mt-3'
                  type='submit'
                  variant='primary'
                  text='Get Started'
                />
              </Col>
            </Col>
          </Row>
        </form>
      </div>
    );
  }
}

const mapStateToProps = state => {
  return {
    signupFormData: state.merchant.signupFormData,
    formErrors: state.merchant.signupFormErrors
  };
};

export default connect(mapStateToProps, actions)(MerchantSignup);
</file>
<file name="./client/app/containers/Address/constants.js" format="js">
/*
 *
 * Address constants
 *
 */

export const FETCH_ADDRESS = 'src/Address/FETCH_ADDRESS';
export const FETCH_ADDRESSES = 'src/Address/FETCH_ADDRESSES';
export const ADDRESS_CHANGE = 'src/Address/ADDRESS_CHANGE';
export const ADDRESS_EDIT_CHANGE = 'src/Address/ADDRESS_EDIT_CHANGE';
export const SET_ADDRESS_FORM_ERRORS = 'src/Address/SET_ADDRESS_FORM_ERRORS';
export const SET_ADDRESS_FORM_EDIT_ERRORS =
  'src/Address/SET_ADDRESS_FORM_EDIT_ERRORS';
export const RESET_ADDRESS = 'src/Address/RESET_ADDRESS';
export const ADD_ADDRESS = 'src/Address/ADD_ADDRESS';
export const REMOVE_ADDRESS = 'src/Address/REMOVE_ADDRESS';
export const SET_ADDRESS_LOADING = 'src/Address/SET_ADDRESS_LOADING';
export const ADDRESS_SELECT = 'src/Brand/BRAND_SELECT';
</file>
<file name="./client/app/containers/Address/reducer.js" format="js">
/*
 *
 * Address reducer
 *
 */

import {
  FETCH_ADDRESS,
  FETCH_ADDRESSES,
  ADDRESS_CHANGE,
  ADDRESS_EDIT_CHANGE,
  SET_ADDRESS_FORM_ERRORS,
  SET_ADDRESS_FORM_EDIT_ERRORS,
  RESET_ADDRESS,
  ADD_ADDRESS,
  REMOVE_ADDRESS,
  SET_ADDRESS_LOADING
} from './constants';

const initialState = {
  addresses: [],
  addressFormData: {
    address: '',
    city: '',
    state: '',
    country: '',
    zipCode: '',
    isDefault: false
  },
  address: {
    _id: '',
    address: '',
    city: '',
    state: '',
    country: '',
    zipCode: '',
    isDefault: false
  },
  formErrors: {},
  editFormErrors: {}
};

const addressReducer = (state = initialState, action) => {
  switch (action.type) {
    case FETCH_ADDRESSES:
      return {
        ...state,
        addresses: action.payload
      };
    case FETCH_ADDRESS:
      return {
        ...state,
        address: action.payload,
        editFormErrors: {}
      };
    case ADD_ADDRESS:
      return {
        ...state,
        addresses: [...state.addresses, action.payload]
      };
    case REMOVE_ADDRESS:
      const index = state.addresses.findIndex(b => b._id === action.payload);
      return {
        ...state,
        addresses: [
          ...state.addresses.slice(0, index),
          ...state.addresses.slice(index + 1)
        ]
      };
    case ADDRESS_CHANGE:
      return {
        ...state,
        addressFormData: {
          ...state.addressFormData,
          ...action.payload
        }
      };
    case ADDRESS_EDIT_CHANGE:
      return {
        ...state,
        address: {
          ...state.address,
          ...action.payload
        }
      };
    case SET_ADDRESS_FORM_ERRORS:
      return {
        ...state,
        formErrors: action.payload
      };
    case SET_ADDRESS_FORM_EDIT_ERRORS:
      return {
        ...state,
        editFormErrors: action.payload
      };
    case RESET_ADDRESS:
      return {
        ...state,
        addressFormData: {
          address: '',
          city: '',
          state: '',
          country: '',
          zipCode: '',
          isDefault: false
        },
        formErrors: {}
      };
    case SET_ADDRESS_LOADING:
      return {
        ...state,
        isLoading: action.payload
      };
    default:
      return state;
  }
};

export default addressReducer;
</file>
<file name="./client/app/containers/Address/Edit.js" format="js">
/*
 *
 * Edit
 *
 */

import React from 'react';

import { connect } from 'react-redux';

import actions from '../../actions';

import EditAddress from '../../components/Manager/EditAddress';
import SubPage from '../../components/Manager/SubPage';
import NotFound from '../../components/Common/NotFound';

class Edit extends React.PureComponent {
  componentDidMount() {
    const addressId = this.props.match.params.id;
    this.props.fetchAddress(addressId);
  }

  componentDidUpdate(prevProps) {
    if (this.props.match.params.id !== prevProps.match.params.id) {
      const addressId = this.props.match.params.id;
      this.props.fetchAddress(addressId);
    }
  }

  render() {
    const {
      history,
      address,
      formErrors,
      addressEditChange,
      defaultChange,
      updateAddress,
      deleteAddress
    } = this.props;

    return (
      <SubPage
        title='Edit Address'
        actionTitle='Cancel'
        handleAction={() => history.goBack()}
      >
        {address?._id ? (
          <EditAddress
            address={address}
            addressChange={addressEditChange}
            formErrors={formErrors}
            updateAddress={updateAddress}
            deleteAddress={deleteAddress}
            defaultChange={defaultChange}
          />
        ) : (
          <NotFound message='No address found.' />
        )}
      </SubPage>
    );
  }
}

const mapStateToProps = state => {
  return {
    address: state.address.address,
    formErrors: state.address.editFormErrors
  };
};

export default connect(mapStateToProps, actions)(Edit);
</file>
<file name="./client/app/containers/Address/index.js" format="js">
/*
 *
 * Address
 *
 */

import React from 'react';

import { connect } from 'react-redux';
import { Switch, Route } from 'react-router-dom';

import actions from '../../actions';

import List from './List';
import Add from './Add';
import Edit from './Edit';
import Page404 from '../../components/Common/Page404';

class Address extends React.PureComponent {
  render() {
    return (
      <div className='address-dashboard'>
        <Switch>
          <Route exact path='/dashboard/address' component={List} />
          <Route exact path='/dashboard/address/edit/:id' component={Edit} />
          <Route exact path='/dashboard/address/add' component={Add} />
          <Route path='*' component={Page404} />
        </Switch>
      </div>
    );
  }
}

const mapStateToProps = state => {
  return {
    user: state.account.user
  };
};

export default connect(mapStateToProps, actions)(Address);
</file>
<file name="./client/app/containers/Address/Add.js" format="js">
/*
 *
 * Add
 *
 */

import React from 'react';

import { connect } from 'react-redux';

import actions from '../../actions';

import AddAddress from '../../components/Manager/AddAddress';
import SubPage from '../../components/Manager/SubPage';

class Add extends React.PureComponent {
  render() {
    const {
      history,
      addressFormData,
      formErrors,
      addressChange,
      addAddress
    } = this.props;

    return (
      <SubPage
        title='Add Address'
        actionTitle='Cancel'
        handleAction={() => history.goBack()}
      >
        <AddAddress
          addressFormData={addressFormData}
          formErrors={formErrors}
          addressChange={addressChange}
          addAddress={addAddress}
        />
      </SubPage>
    );
  }
}

const mapStateToProps = state => {
  return {
    addressFormData: state.address.addressFormData,
    formErrors: state.address.formErrors
  };
};

export default connect(mapStateToProps, actions)(Add);
</file>
<file name="./client/app/containers/Address/actions.js" format="js">
/*
 *
 * Address actions
 *
 */

import { goBack } from 'connected-react-router';
import { success } from 'react-notification-system-redux';
import axios from 'axios';

import {
  FETCH_ADDRESS,
  FETCH_ADDRESSES,
  ADDRESS_CHANGE,
  ADDRESS_EDIT_CHANGE,
  SET_ADDRESS_FORM_ERRORS,
  SET_ADDRESS_FORM_EDIT_ERRORS,
  RESET_ADDRESS,
  ADD_ADDRESS,
  REMOVE_ADDRESS,
  SET_ADDRESS_LOADING,
  ADDRESS_SELECT
} from './constants';
import handleError from '../../utils/error';
import { allFieldsValidation } from '../../utils/validation';
import { API_URL } from '../../constants';

export const addressChange = (name, value) => {
  let formData = {};
  formData[name] = value;

  return {
    type: ADDRESS_CHANGE,
    payload: formData
  };
};

export const addressEditChange = (name, value) => {
  let formData = {};
  formData[name] = value;

  return {
    type: ADDRESS_EDIT_CHANGE,
    payload: formData
  };
};

export const handleAddressSelect = value => {
  return {
    type: ADDRESS_SELECT,
    payload: value
  };
};

export const setAddressLoading = value => {
  return {
    type: SET_ADDRESS_LOADING,
    payload: value
  };
};

export const fetchAddresses = () => {
  return async (dispatch, getState) => {
    try {
      dispatch(setAddressLoading(true));
      const response = await axios.get(`${API_URL}/address`);
      dispatch({ type: FETCH_ADDRESSES, payload: response.data.addresses });
    } catch (error) {
      handleError(error, dispatch);
    } finally {
      dispatch(setAddressLoading(false));
    }
  };
};

// fetch address api
export const fetchAddress = addressId => {
  return async (dispatch, getState) => {
    try {
      const response = await axios.get(`${API_URL}/address/${addressId}`);

      dispatch({
        type: FETCH_ADDRESS,
        payload: response.data.address
      });
    } catch (error) {
      handleError(error, dispatch);
    }
  };
};

export const addAddress = () => {
  return async (dispatch, getState) => {
    try {
      const rules = {
        address: 'required',
        city: 'required',
        state: 'required',
        country: 'required',
        zipCode: 'required|min:5'
      };

      const newAddress = getState().address.addressFormData;
      const isDefault = getState().address.isDefault;

      const { isValid, errors } = allFieldsValidation(newAddress, rules, {
        'required.address': 'Address is required.',
        'required.city': 'City is required.',
        'required.state': 'State is required.',
        'required.country': 'Country is required.',
        'required.zipCode': 'Zipcode is required.'
      });

      if (!isValid) {
        return dispatch({ type: SET_ADDRESS_FORM_ERRORS, payload: errors });
      }

      const address = {
        isDefault,
        ...newAddress
      };

      const response = await axios.post(`${API_URL}/address/add`, address);

      const successfulOptions = {
        title: `${response.data.message}`,
        position: 'tr',
        autoDismiss: 1
      };

      if (response.data.success === true) {
        dispatch(success(successfulOptions));
        dispatch({
          type: ADD_ADDRESS,
          payload: response.data.address
        });
        dispatch(goBack());
        dispatch({ type: RESET_ADDRESS });
      }
    } catch (error) {
      handleError(error, dispatch);
    }
  };
};

// update address api
export const updateAddress = () => {
  return async (dispatch, getState) => {
    try {
      const rules = {
        country: 'required',
        city: 'required',
        state: 'required',
        address: 'required',
        zipCode: 'required'
      };

      const newAddress = getState().address.address;

      const { isValid, errors } = allFieldsValidation(newAddress, rules, {
        'required.address': 'Address is required.',
        'required.city': 'City is required.',
        'required.state': 'State is required.',
        'required.country': 'Country is required.',
        'required.zipCode': 'Zipcode is required.'
      });

      if (!isValid) {
        return dispatch({
          type: SET_ADDRESS_FORM_EDIT_ERRORS,
          payload: errors
        });
      }

      const response = await axios.put(
        `${API_URL}/address/${newAddress._id}`,
        newAddress
      );

      const successfulOptions = {
        title: `${response.data.message}`,
        position: 'tr',
        autoDismiss: 1
      };

      if (response.data.success === true) {
        dispatch(success(successfulOptions));
        dispatch(goBack());
      }
    } catch (error) {
      handleError(error, dispatch);
    }
  };
};

// delete address api
export const deleteAddress = id => {
  return async (dispatch, getState) => {
    try {
      const response = await axios.delete(`${API_URL}/address/delete/${id}`);

      const successfulOptions = {
        title: `${response.data.message}`,
        position: 'tr',
        autoDismiss: 1
      };

      if (response.data.success === true) {
        dispatch(success(successfulOptions));
        dispatch({
          type: REMOVE_ADDRESS,
          payload: id
        });
        dispatch(goBack());
      }
    } catch (error) {
      handleError(error, dispatch);
    }
  };
};
</file>
<file name="./client/app/containers/Address/List.js" format="js">
/*
 *
 * List
 *
 */

import React from 'react';

import { connect } from 'react-redux';

import actions from '../../actions';

import AddressList from '../../components/Manager/AddressList';
import SubPage from '../../components/Manager/SubPage';
import NotFound from '../../components/Common/NotFound';

class List extends React.PureComponent {
  componentDidMount() {
    this.props.fetchAddresses();
  }

  render() {
    const { history, addresses } = this.props;

    return (
      <>
        <SubPage
          title='Addresses'
          actionTitle={'Add'}
          handleAction={() => history.push('/dashboard/address/add')}
        >
          {addresses.length > 0 ? (
            <AddressList addresses={addresses} />
          ) : (
            <NotFound message='No addresses found.' />
          )}
        </SubPage>
      </>
    );
  }
}

const mapStateToProps = state => {
  return {
    addresses: state.address.addresses
  };
};

export default connect(mapStateToProps, actions)(List);
</file>
<file name="./client/app/scrollToTop.js" format="js">
/**
 *
 * scrollToTop.js
 * scroll restoration
 */

import React from 'react';

import { withRouter } from 'react-router-dom';

class ScrollToTop extends React.Component {
  componentDidUpdate(prevProps) {
    if (this.props.location.pathname !== prevProps.location.pathname) {
      window.scroll({
        top: 0,
        behavior: 'smooth'
      });
    }
  }

  render() {
    return this.props.children;
  }
}

export default withRouter(ScrollToTop);
</file>
<file name="./client/app/reducers.js" format="js">
/*
 *
 * reducers.js
 * reducers configuration
 */

import { combineReducers } from 'redux';
import { connectRouter } from 'connected-react-router';
import { reducer as notifications } from 'react-notification-system-redux';

// import reducers
import applicationReducer from './containers/Application/reducer';
import homepageReducer from './containers/Homepage/reducer';
import signupReducer from './containers/Signup/reducer';
import loginReducer from './containers/Login/reducer';
import forgotPasswordReducer from './containers/ForgotPassword/reducer';
import navigationReducer from './containers/Navigation/reducer';
import authenticationReducer from './containers/Authentication/reducer';
import cartReducer from './containers/Cart/reducer';
import newsletterReducer from './containers/Newsletter/reducer';
import dashboardReducer from './containers/Dashboard/reducer';
import accountReducer from './containers/Account/reducer';
import addressReducer from './containers/Address/reducer';
import resetPasswordReducer from './containers/ResetPassword/reducer';
import usersReducer from './containers/Users/reducer';
import productReducer from './containers/Product/reducer';
import categoryReducer from './containers/Category/reducer';
import brandReducer from './containers/Brand/reducer';
import navigationMenuReducer from './containers/NavigationMenu/reducer';
import shopReducer from './containers/Shop/reducer';
import merchantReducer from './containers/Merchant/reducer';
import contactReducer from './containers/Contact/reducer';
import orderReducer from './containers/Order/reducer';
import reviewReducer from './containers/Review/reducer';
import wishListReducer from './containers/WishList/reducer';

const createReducer = history =>
  combineReducers({
    router: connectRouter(history),
    notifications,
    application: applicationReducer,
    homepage: homepageReducer,
    signup: signupReducer,
    login: loginReducer,
    forgotPassword: forgotPasswordReducer,
    navigation: navigationReducer,
    authentication: authenticationReducer,
    cart: cartReducer,
    newsletter: newsletterReducer,
    dashboard: dashboardReducer,
    account: accountReducer,
    address: addressReducer,
    resetPassword: resetPasswordReducer,
    users: usersReducer,
    product: productReducer,
    category: categoryReducer,
    brand: brandReducer,
    menu: navigationMenuReducer,
    shop: shopReducer,
    merchant: merchantReducer,
    contact: contactReducer,
    order: orderReducer,
    review: reviewReducer,
    wishlist: wishListReducer
  });

export default createReducer;
</file>
<file name="./client/app/store.js" format="js">
/**
 *
 * store.js
 * store configuration
 */

import { createStore, compose, applyMiddleware } from 'redux';
import thunk from 'redux-thunk';
import { routerMiddleware } from 'connected-react-router';
import { createBrowserHistory } from 'history';

import createReducer from './reducers';

export const history = createBrowserHistory({
  basename: '/',
  hashType: 'noslash'
});

const middlewares = [thunk, routerMiddleware(history)];

const enhancers = [applyMiddleware(...middlewares)];

// If Redux DevTools Extension is installed use it, otherwise use Redux compose
const composeEnhancers =
  process.env.NODE_ENV !== 'production' &&
  typeof window === 'object' &&
  window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__
    ? window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__({})
    : compose;

const store = createStore(
  createReducer(history),
  composeEnhancers(...enhancers)
);

if (module.hot) {
  // Enable Webpack hot module replacement for reducers
  module.hot.accept('./reducers', () => {
    const nextRootReducer = require('./reducers').default; // eslint-disable-line global-require
    store.replaceReducer(nextRootReducer(history));
  });
}

export default store;
</file>
<file name="./client/app/styles/core/_button.scss" format="scss">
// start input button styles
input[type='button'],
input[type='submit'],
input[type='reset'],
button[type='button'],
button[type='submit'],
button[type='reset'],
button {
  border: none;
  background: transparent;
  color: $font-custom-color !important;
  font-size: $font-size-small;
  font-weight: $font-weight-medium;
  text-decoration: none;
  text-transform: capitalize;
  cursor: pointer;

  &:focus {
    outline: none;
  }

  :active {
    outline: none;
  }

  &:disabled {
    background-color: $disabled-bg;
    border-color: transparent !important;
    pointer-events: none;
  }
}
// end input button styles

// basic styles
.input-btn {
  padding: 0;

  .btn-text {
    font-weight: $font-weight-medium;
    font-size: $font-size-small;
  }
}

// size
.input-btn {
  &.icon-only {
    padding: 0 !important;
    min-width: auto !important;

    &.sm {
      width: 22px;
      height: 22px;
    }

    &.md {
      width: 30px;
      height: 30px;
    }

    &.lg {
      width: 40px;
      height: 40px;
    }
  }

  &.sm {
    padding: 6px 10px;
    min-width: 100px;

    .btn-text {
      font-size: $font-size-x-small;
    }
  }

  &.md {
    padding: 10px 16px;
    min-width: 135px;
  }
}

// primary button
.input-btn {
  &.custom-btn-primary {
    position: relative;
    border: $border-default;
    background-color: $btn-bg;
    -webkit-transition: $layout-transition-speed;
    transition: $layout-transition-speed;

    .btn-text {
      -webkit-transition: $layout-transition-speed;
      transition: $layout-transition-speed;
    }

    &:hover {
      background-color: $primary-bg;

      .btn-text {
        color: $white !important;
        -webkit-transition: $layout-transition-speed;
        transition: $layout-transition-speed;
      }
    }
  }
}

// secondary button
.input-btn {
  &.custom-btn-secondary {
    position: relative;
    border: $border-default;
    background-color: $btn-bg;
    -webkit-transition: $layout-transition-speed;
    transition: $layout-transition-speed;

    .btn-text {
      -webkit-transition: $layout-transition-speed;
      transition: $layout-transition-speed;
    }

    &:hover {
      background-color: $secondary-bg;
      color: $font-custom-color !important;

      .btn-text {
        -webkit-transition: $layout-transition-speed;
        transition: $layout-transition-speed;
      }
    }
  }
}

body.user-is-tabbing button:focus {
  box-shadow: none;
  outline: 1px dotted;
}

// danger button
.input-btn {
  &.custom-btn-danger {
    position: relative;
    border: $border-default;
    background-color: $danger-bg;
    -webkit-transition: $layout-transition-speed;
    transition: $layout-transition-speed;

    .btn-text {
      color: $white !important;
      -webkit-transition: $layout-transition-speed;
      transition: $layout-transition-speed;
    }

    &:hover {
      background-color: $danger-hover-bg;

      .btn-text {
        -webkit-transition: $layout-transition-speed;
        transition: $layout-transition-speed;
        color: $white !important;
      }
    }
  }
}

// none button
.input-btn {
  &.custom-btn-none {
    position: relative;
    min-width: auto;
    border: $border-default;

    &:hover {
      color: $font-custom-color !important;
    }
  }
}

// link button
.input-btn {
  &.custom-btn-link {
    position: relative;
    -webkit-transition: $layout-transition-speed;
    transition: $layout-transition-speed;

    .btn-text {
      font-weight: $font-weight-normal;
      -webkit-transition: $layout-transition-speed;
      transition: $layout-transition-speed;
    }

    &:hover {
      .btn-text {
        opacity: 0.9;
        -webkit-transition: $layout-transition-speed;
        transition: $layout-transition-speed;
      }
    }
  }
}

// dark button
.input-btn {
  &.custom-btn-dark {
    position: relative;
    border: $border-default;
    background-color: $dark-bg;
    -webkit-transition: $layout-transition-speed;
    transition: $layout-transition-speed;

    .btn-text {
      color: $white !important;
      -webkit-transition: $layout-transition-speed;
      transition: $layout-transition-speed;
    }

    &:hover {
      background-color: $dark-hover-bg;

      .btn-text {
        -webkit-transition: $layout-transition-speed;
        transition: $layout-transition-speed;
        color: $white !important;
      }
    }
  }
}

// button link
.btn-link {
  padding: 10px;
  border: $border-default;
  display: inline-block;
  min-width: 150px;
  font-weight: $font-weight-normal;
  color: $font-custom-color !important;
  background-color: $btn-bg;
  -webkit-transition: $layout-transition-speed;
  transition: $layout-transition-speed;

  &:hover {
    color: $white !important;
    background-color: $btn-bg-hover;
    -webkit-transition: $layout-transition-speed;
    transition: $layout-transition-speed;
  }
}

// button icon styles
.input-btn {
  .btn-icon {
    display: inline-flex;
    vertical-align: bottom;
    line-height: 100%;
  }

  // text only styles
  &.text-only {
    .btn-text {
      letter-spacing: 0.9px;
    }
  }

  &.custom-btn-primary {
    &.with-icon {
      &:hover {
        border-color: transparent;
        -webkit-transition: $layout-transition-speed;
        transition: $layout-transition-speed;

        svg {
          fill: $white;
          stroke: $white !important;
          -webkit-transition: $layout-transition-speed;
          transition: $layout-transition-speed;
        }
      }
    }
  }

  &.custom-btn-danger {
    &.with-icon {
      &:hover {
        border-color: transparent;
        -webkit-transition: $layout-transition-speed;
        transition: $layout-transition-speed;

        svg {
          fill: $white;
          stroke: $white !important;
          -webkit-transition: $layout-transition-speed;
          transition: $layout-transition-speed;
        }
      }
    }
  }

  // with icon styles
  &.with-icon {
    &.icon-left {
      .btn-icon {
        margin-right: 6px;
      }
      .btn-text {
        margin-right: 5px;
      }
    }
    &.icon-right {
      .btn-icon {
        margin-left: 6px;
      }
      .btn-text {
        margin-left: 5px;
      }
    }
  }
}

// bag button
.input-btn {
  &.bag-btn {
    box-shadow: $box-shadow-custom;
    min-width: 185px;
    @include media-breakpoint-down(sm) {
      width: 100% !important;
    }

    &:focus {
      &.with-icon {
        background-color: $primary-bg;
        border-color: transparent;
        -webkit-transition: $layout-transition-speed;
        transition: $layout-transition-speed;

        .btn-text {
          color: $white;
          -webkit-transition: $layout-transition-speed;
          transition: $layout-transition-speed;
        }

        svg {
          fill: $white;
          stroke: $white !important;
          -webkit-transition: $layout-transition-speed;
          transition: $layout-transition-speed;
        }
      }
    }
  }
}

.bag-icon {
  cursor: pointer;
  width: 20px;
  height: 20px;
  stroke-width: 20px;
  stroke: $black;
  -webkit-transition: $layout-transition-speed;
  transition: $layout-transition-speed;
}

.close-icon {
  cursor: pointer;
  position: relative;
  background-size: 16px;
  @include icon($close, 25px, 25px);

  &:hover {
    opacity: 0.5;
  }
}
</file>
<file name="./client/app/styles/core/_badge.scss" format="scss">
.custom-badge {
  padding: 8px 10px;
  //   border-radius: $border-radius-default;
  font-weight: $font-weight-normal;
}

.custom-badge-primary {
  background-color: $primary-bg;
  color: $white;
}

.custom-badge-secondary {
  background-color: $secondary-bg;
}

.custom-badge-dark {
  background-color: $dark-bg;
  color: $white;
}

.custom-badge-danger {
  background-color: $danger-bg;
  color: $white;
}
</file>
<file name="./client/app/styles/core/_coming-soon.scss" format="scss">
.coming-soon {
  animation: shake 0.82s cubic-bezier(0.36, 0.07, 0.19, 0.97) both;
  animation-iteration-count: 1;
  transform: translate3d(0, 0, 0);
  backface-visibility: hidden;
  perspective: 1000px;
  text-align: center;
}

@keyframes shake {
  10%,
  90% {
    transform: translate3d(-1px, 0, 0);
  }

  20%,
  80% {
    transform: translate3d(2px, 0, 0);
  }

  30%,
  50%,
  70% {
    transform: translate3d(-4px, 0, 0);
  }

  40%,
  60% {
    transform: translate3d(4px, 0, 0);
  }
}
</file>
<file name="./client/app/styles/core/_switch.scss" format="scss">
.switch-checkbox {
  .switch-checkbox-input {
    @include sr-only();
  }

  .switch-checkbox-input + .switch-label {
    display: inline-flex;
    align-items: center;
  }

  .switch-checkbox-input + .switch-label .switch-label-text {
    font-weight: $font-weight-medium;
    margin-right: 10px;
  }

  .switch-checkbox-input + .switch-label .switch-label-toggle {
    justify-content: space-between;
    cursor: pointer;
    width: 40px;
    height: 25px;
    background: grey;
    border-radius: 100px;
    position: relative;
    @include transition();
  }

  .switch-checkbox-input + .switch-label .switch-label-toggle::before {
    content: '';
    position: absolute;
    top: 2px;
    left: 2px;
    width: 20px;
    height: 20px;
    border-radius: $border-radius-circle;
    background-color: $white;
    @include transition();
  }

  .switch-checkbox-input:checked + .switch-label .switch-label-toggle::before {
    left: calc(100% - 2px);
    transform: translateX(-100%);
  }

  .switch-checkbox-input:checked + .switch-label .switch-label-toggle {
    background: $theme-green;
  }
}
</file>
<file name="./client/app/styles/core/_product.scss" format="scss">
/* start product dashboard styles */
.product-dashboard {
  .p-list {
    .product-box {
      height: 120px;
      max-height: 120px;
      border-radius: $border-radius-default;
      box-shadow: $box-shadow-secondary;
      @include transition();

      &:hover {
        background-color: $secondary-bg;
        @include transition();
      }

      .item-image {
        width: 120px;
        min-width: 120px;
        height: 120px;
        object-fit: cover;
        border-radius: $border-radius-default;
      }

      .product-desc {
        @include text-ellipsis(2);
      }
    }
  }
}
/* end product dashboard styles */

/* start product list styles */
.product-list {
  @include media-breakpoint-up(md) {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    grid-gap: 12px;
  }

  @include media-breakpoint-up(lg) {
    grid-template-columns: repeat(3, 1fr);
  }

  @include media-breakpoint-up(xl) {
    grid-template-columns: repeat(4, 1fr);
  }

  .product-container {
    background-color: $white;
    box-shadow: $box-shadow-primary;
    border-radius: $border-radius-default;
    height: 100%;

    .item-box {
      height: 100%;
      position: relative;

      .add-wishlist-box {
        position: absolute;
        top: 10px;
        right: 10px;
        z-index: 1;
      }

      .item-link {
        display: flex;
        flex-direction: column;
        height: 100%;
        flex: 1 auto;
      }

      .item-footer {
        min-height: 50px;
      }

      .item-image-container {
        overflow: hidden;
        position: relative;

        .item-image-box {
          padding-bottom: 100%;
          position: relative;
          -webkit-box-flex: 1;
          -webkit-flex-grow: 1;
          -ms-flex-positive: 1;
          flex-grow: 1;
          background-color: $white;
          -webkit-filter: brightness(0.975);
          filter: brightness(0.975);

          .item-image {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            margin: auto;
            max-width: 100%;
            max-height: 100%;
          }
        }
      }

      .item-body {
        flex: 1 1 auto;
        .item-details {
          display: flex;
          flex-direction: column;
          // height: 100%;

          .item-name {
            margin-bottom: 8px;
            @include text-ellipsis(1);
          }

          .item-desc {
            @include text-ellipsis(2);
          }

          .by {
            margin-bottom: 5px;
            color: $font-subtext-color !important;

            span {
              font-weight: $font-weight-normal;
            }
          }
        }
      }
    }
  }
}
/* end product list styles */

/* start product page styles */
.product-page {
  .main {
    background-color: $theme-white;
  }
}

.product-shop {
  .stock {
    position: absolute;
    top: 0;
    right: 0;
    padding: 10px;
    background-color: $white;
    border-bottom-left-radius: $border-radius-default;
  }

  .product-container {
    background-color: $white;
    padding: 20px;
    box-shadow: $box-shadow-primary;
    border-radius: $border-radius-default;
    @include flex();
    flex-direction: column;
    height: 100%;
  }

  .review-container {
    background-color: $white;
    padding: 20px;
    box-shadow: $box-shadow-primary;
    border-radius: $border-radius-default;
    @include flex();
    flex-direction: column;
    height: 100%;
  }

  .item-box {
    .item-name {
      font-size: $font-size-huge !important;
    }

    .item-details {
      .item-desc {
        color: $font-custom-color !important;
        word-break: break-all;
      }

      .price {
        font-size: $font-size-x-huge;
      }
    }

    .item-actions {
      margin-top: 20px;
    }
  }
}
/* end product page styles */

/* start product common styles */
.item-box {
  .item-link {
    display: block;

    .item-name {
      &:hover {
        color: $font-custom-hover-color !important;
      }
    }
  }

  .item-name {
    color: $primary-color !important;
    font-size: $font-size-heading-small !important;
    font-weight: $font-weight-medium;
    margin: 0px;
  }

  .item-label {
    color: $font-custom-color;
    font-weight: $font-weight-normal;
    text-transform: capitalize;
  }

  .item-value {
    color: $font-custom-color;
    font-weight: $font-weight-medium;
    font-size: $font-size-large;
  }

  .price {
    color: $font-custom-color;
    font-weight: $font-weight-normal;
    font-size: $font-size-huge;
  }

  .by {
    text-transform: capitalize;
  }
}

.stock {
  font-weight: $font-weight-normal;
}

.in-stock {
  color: $primary-color;
}

.out-of-stock {
  color: $theme-bright-red;
}
/* end product common styles */
</file>
<file name="./client/app/styles/core/_checkbox.scss" format="scss">
.checkbox {
  input[type='checkbox'] {
    @include sr-only();
  }

  &.default-icon {
    margin: 10px 0px;
    display: inline-block;

    input[type='checkbox'] + label {
      display: block;
      position: relative;
      padding: 5px 5px 5px 30px;
      color: $font-custom-color;
      cursor: pointer;
      user-select: none;
      -webkit-user-select: none;
      -moz-user-select: none;
      -ms-user-select: none;
    }

    input[type='checkbox'] + label:last-child {
      margin-bottom: 0;
    }

    input[type='checkbox'] + label:before {
      content: '';
      display: block;
      width: 18px;
      height: 16px;
      border: $border-default;
      border-color: $primary-color;
      position: absolute;
      left: 4px;
      top: 7px;
      opacity: 0.6;
      -webkit-transition: all 0.12s, border-color 0.08s;
      transition: all 0.12s, border-color 0.08s;
    }

    input[type='checkbox']:checked + label:before {
      width: 8px;
      left: 12px;
      top: 5px;
      border-radius: 0;
      opacity: 1;
      border-top-color: transparent;
      border-left-color: transparent;
      -webkit-transform: rotate(45deg);
      transform: rotate(45deg);
    }
  }
}

body.user-is-tabbing input[type='checkbox']:focus + label {
  // outline: 2px solid $outline-color !important;
  // outline: 2px auto -webkit-focus-ring-color !important;

  box-shadow: none;
  outline: 1px dotted;
}
</file>
<file name="./client/app/styles/core/_support.scss" format="scss">
.support {
  .u-list {
    li {
      position: relative;
      border: 1px solid $border-color-default;
      border-bottom: none;

      &:last-child {
        border-bottom: 1px solid $border-color-default;
      }

      .circle {
        width: 8px;
        height: 8px;
        border-radius: $border-radius-circle;

        &.online {
          background-color: $green;
        }
        &.offline {
          background-color: $red;
        }
      }

      .input-btn {
        width: 100%;

        .btn-icon {
          vertical-align: inherit;
        }

        &:disabled {
          background-color: $disabled-bg;
          border: none !important;
          cursor: not-allowed;
        }
      }

      &.selected {
        .input-btn {
          &:not([disabled]) {
            background-color: $secondary-bg;
          }
        }
      }
    }
  }

  .m-list {
    min-height: 30vh;
    max-height: 70vh;
    overflow-x: hidden;
    overflow-y: scroll;
    padding: 40px 20px 20px 0px;
    position: relative;
    // background-color: $theme-gray;

    &::-webkit-scrollbar-thumb {
      background: $theme-light-white;
    }
    &::-webkit-scrollbar-track {
      background: $white;
    }

    &.empty {
      justify-content: center;
      align-items: center;
      @include flex();
    }

    .avatar {
      width: 32px;
      height: 32px;
    }

    .avatar-box {
      width: 40px;
    }

    .m-box {
      background-color: $secondary-bg;
      border-radius: $border-radius-primary;
      box-shadow: $box-shadow-secondary;
      color: $black;
      width: fit-content;
      padding: 0.5rem 0.875rem;
      position: relative;
      word-wrap: break-word;
      line-height: 1.25;
      flex: 1;
      justify-content: center;
      align-items: center;
      @include flex();

      &.me {
        background-color: $primary-bg;
        color: $white;
        align-self: flex-end;
        margin-left: auto;
      }
    }
  }
}
</file>
<file name="./client/app/styles/core/_homepage.scss" format="scss">
// .homepage {
// }
</file>
<file name="./client/app/styles/core/_layout.scss" format="scss">
// layout styles

html {
  overflow: visible;
  -ms-text-size-adjust: 100%;
  -webkit-text-size-adjust: 100%;
}

body {
  background-color: $white;
  color: $font-color !important;
  font-family: $font-family-body;
  font-size: $font-size-small;
  font-weight: $font-weight-normal;
  height: 100%;
  letter-spacing: $letter-spacing;
  line-height: $line-height;
  margin: 0;
  padding: 0;
  position: relative;
  text-rendering: optimizeLegibility;
  // -webkit-font-smoothing: antialiased;
}

.application {
  @include flex();
  flex-direction: column;
  min-height: 100vh;
}

main {
  flex: 1 0 auto;
}

html {
  scroll-behavior: smooth;
}

html,
body {
  height: 100%;
  margin: 0;
}

.wrapper {
  padding: 260px 0px 25px;

  @include media-breakpoint-up(md) {
    padding: 25px 0px;
  }
}

img {
  border-style: none;
  vertical-align: middle;
}

span,
label,
a,
p {
  font-size: $font-size-medium;
  color: $font-custom-color;
}

label {
  cursor: default;
  // text-transform: capitalize;
  margin: 0;
  font-weight: $font-weight-normal;
}

a {
  color: $font-color !important;
  text-decoration: none !important;
  -moz-transition: color $layout-transition-speed ease-in-out;
  -webkit-transition: color $layout-transition-speed ease-in-out;
  -ms-transition: color $layout-transition-speed ease-in-out;
  transition: color $layout-transition-speed ease-in-out;

  &:hover {
    color: $font-hover-color !important;
    -moz-transition: color $layout-transition-speed ease-in-out;
    -webkit-transition: color $layout-transition-speed ease-in-out;
    -ms-transition: color $layout-transition-speed ease-in-out;
    transition: color $layout-transition-speed ease-in-out;
  }

  &:focus {
    outline: none;
  }
}

body.user-is-tabbing a:focus {
  box-shadow: none;
  outline: 1px dotted;
}

h1,
h2,
h3,
h4,
h5,
h6,
.h1,
.h2,
.h3,
.h4,
.h5,
.h6 {
  color: $font-heading-color !important;
  font-family: $font-family-heading;
  font-size: $font-size-heading-medium !important;
  line-height: $line-height !important;
  // text-transform: capitalize;
}

h1,
.h1 {
  font-size: 2em !important;
  font-weight: $font-weight-bold;
}

h2,
.h2 {
  font-size: 1.4em !important;
  font-weight: $font-weight-semibold;
}

h3,
.h3 {
  font-size: 1.27em !important;
  font-weight: $font-weight-medium;
}

h4,
.h4 {
  font-size: 1.18em !important;
  font-weight: $font-weight-medium;
}

h5,
.h5 {
  font-size: 1.12em !important;
  font-weight: $font-weight-normal;
}

h6,
.h6 {
  font-size: 1em !important;
  font-weight: $font-weight-normal;
}

/* scrollbar styles */
::-webkit-scrollbar {
  width: 10px;
  height: 10px;
}

::-webkit-scrollbar-thumb {
  background: $white;
  border-left: $border-default;
  border-color: $theme-light-white;
}

::-webkit-scrollbar-track {
  background: $theme-dark-gray;
}
/* scrollbar styles */

body.user-is-tabbing *:focus {
  // outline: 2px solid $outline-color !important;
  // outline: 2px auto -webkit-focus-ring-color !important;
  // outline: 1px dotted !important;
  outline: none;
  box-shadow: $outline-box-shadow;
  border-radius: $border-radius-default;
}
</file>
<file name="./client/app/styles/core/_share.scss" format="scss">
.share-box {
  li {
    margin-right: 14px;

    &:last-child {
      margin-right: 0;
    }

    .share-btn {
      @include flex();
      flex-direction: column;
      justify-content: center;
      align-items: center;
      width: 35px;
      height: 35px;
      border-radius: $border-radius-circle;
      color: $white !important;

      &:focus {
        outline: none;
        box-shadow: $outline-box-shadow;
      }

      .fa {
        font-size: $font-size-x-large;

        &.fa-whatsapp {
          font-size: $font-size-xx-large;
        }
      }

      &.facebook {
        background-color: #4267b2 !important;
      }

      &.twitter {
        background-color: #1da1f2 !important;
      }

      &.envelope {
        background-color: $theme-yellow !important;
      }

      &.whatsapp {
        background-color: #128c7e !important;
      }
    }
  }
}
</file>
<file name="./client/app/styles/core/_menu.scss" format="scss">
// mini menu
.mini-menu {
  visibility: hidden;
  position: fixed;
  top: 0;
  left: -100%;
  background: $white;
  height: 100%;
  width: 370px;
  z-index: 1000;
  // -webkit-box-shadow: $box-shadow;
  // box-shadow: $box-shadow;
  @include transition($layout-transition-higher-speed);

  @include media-breakpoint-down(xs) {
    width: 88%;
    top: 0;
  }
}

// show hidden menu popup
.mini-menu-open {
  .mini-menu {
    visibility: visible;
    left: 0;
    @include transition($layout-transition-higher-speed);
  }

  .dark-overflow {
    @include dark-overflow();
    @include media-breakpoint-down(xs) {
      width: 100%;
      top: 0;
    }
  }
}

.navigation-menu {
  height: 100%;
  background-color: $theme-white;

  .menu-header {
    border-bottom: $border-default;
    text-align: right;
    padding-right: 5px;
    align-items: center;
    justify-content: flex-end;
    height: 50px;
    @include flex();
  }

  .menu-title {
    padding: 10px 0px 10px 30px;
  }

  .menu-body {
    margin-top: 20px;

    .menu-list {
      .menu-item {
        a {
          color: $font-custom-color !important;
          font-weight: $font-weight-normal;
          text-transform: capitalize;
          display: block;
          padding: 10px 30px 10px 30px;
          border-left: 3px solid transparent;
          @include transition();

          &:hover {
            background-color: $white;
            border-left: 3px solid $primary-color;
            color: $primary-color !important;
            @include transition();
          }

          &:focus {
            outline: none;
            box-shadow: none;
            background-color: $white;
            border-left: 3px solid $primary-color;
          }

          &.active-line {
            font-weight: $font-weight-medium;
            background-color: $white;
            color: $primary-color !important;
            border-color: $primary-color;
            @include transition();
          }
        }
      }
    }
  }
}
</file>
<file name="./client/app/styles/core/_input.scss" format="scss">
// start input text styles
input[type='text'],
input[type='number'],
input[type='password'],
input[type='file'],
textarea {
  width: 100%;
  padding: 8px 10px;
  border: $border-default;
  font-size: $font-size-medium;
  color: $font-custom-color;
  border-radius: $border-radius-default;
  -webkit-transition: $layout-transition-speed;
  transition: $layout-transition-speed;
  cursor: text;
  @include appearance();

  &:focus {
    outline: none;
    color: $font-focus-color;
    border-color: $border-focus-color !important;
    box-shadow: none;
    -webkit-transition: $layout-transition-speed;
    transition: $layout-transition-speed;
  }

  &:disabled {
    background-color: $disabled-bg;
    border: none !important;
    cursor: not-allowed;
  }
}

body.user-is-tabbing textarea {
  box-shadow: none !important;
}
// end input text styles

.input-box,
.select-box {
  .invalid-message {
    visibility: hidden;
    opacity: 0;
    color: $validation-color;
    height: 0;
    @include flex();
    -webkit-transition: $layout-transition-speed;
    transition: $layout-transition-speed;
  }

  &.invalid {
    .input-text,
    textarea {
      border-color: $validation-color;
      -webkit-transition: $layout-transition-speed;
      transition: $layout-transition-speed;

      &:focus {
        border-color: $validation-color !important;
      }
    }

    .invalid-message {
      visibility: visible;
      opacity: 1;
      height: 100%;
      margin-top: 5px;
      -webkit-transition: $layout-transition-speed;
      transition: $layout-transition-speed;
    }
  }
}

.input-box {
  margin: 10px 0px;

  input[type='text'],
  input[type='number'],
  input[type='password'],
  input[type='file'] {
    height: 45px;
  }

  label {
    margin-bottom: 5px;
    color: $font-custom-color;
    font-size: $font-size-medium;
  }
}

.inline-btn-box {
  .input-text-block {
    @include flex();
    flex-direction: row;
  }

  .input-text {
    border-top-right-radius: 0;
    border-bottom-right-radius: 0;
  }

  .input-btn {
    border-left: none !important;
    border-top-left-radius: 0 !important;
    border-bottom-left-radius: 0 !important;
  }
}

.select-box {
  margin: 10px 0px;

  label {
    margin-bottom: 5px;
    color: $font-custom-color;
    font-size: $font-size-medium;
  }

  .select-container {
    .select-option__multi-value__label {
      font-weight: $font-weight-normal;
      font-size: $font-size-small;
    }
  }
}

@include placeholder {
  font-size: $font-size-small;
  line-height: $line-height;
  text-transform: capitalize;
}
</file>
<file name="./client/app/styles/core/_review.scss" format="scss">
.product-reviews {
  .fa {
    font-size: $font-size-x-large;
  }

  .review-summary {
    .left {
      width: 20%;

      @include media-breakpoint-up(md) {
        width: 25%;
      }
      @include media-breakpoint-up(lg) {
        width: 15%;
      }
    }
    .middle {
      width: 60%;

      @include media-breakpoint-up(md) {
        width: 50%;
      }
      @include media-breakpoint-up(lg) {
        width: 70%;
      }
    }
    .right {
      width: 20%;
      text-align: right;

      @include media-breakpoint-up(md) {
        width: 25%;
      }

      @include media-breakpoint-up(lg) {
        width: 15%;
      }
    }

    .bar-container {
      width: 100%;
      background-color: #f1f1f1;
      text-align: center;
      color: white;
    }
    .bar-5 {
      height: 16px;
      background-color: #4caf50;
    }
    .bar-4 {
      height: 16px;
      background-color: #2196f3;
    }
    .bar-3 {
      height: 16px;
      background-color: #00bcd4;
    }
    .bar-2 {
      height: 16px;
      background-color: #ff9800;
    }
    .bar-1 {
      height: 16px;
      background-color: #f44336;
    }
  }

  .review-list {
    .review-box {
      height: 100%;
      border-radius: $border-radius-default;
      box-shadow: $box-shadow-secondary;
      background-color: $white;

      .avatar {
        width: 40px;
        height: 40px;
      }

      .review-icon {
        width: 35px;
        height: 35px;

        @include media-breakpoint-up(lg) {
          width: 50px;
          height: 50px;
        }
      }
    }
  }
}

.review-dashboard {
  .r-list {
    .review-box {
      border-radius: $border-radius-default;
      box-shadow: $box-shadow-secondary;

      .avatar {
        width: 30px;
        height: 30px;
        font-size: $font-size-x-small;

        @include media-breakpoint-up(md) {
          width: 40px;
          height: 40px;
          font-size: $font-size-medium;
        }
      }

      .review-content {
        width: 100%;

        @include media-breakpoint-up(lg) {
          width: 80%;
        }
      }
    }

    .review-product-box {
      @include media-breakpoint-up(lg) {
        width: 80%;
      }
    }

    .item-image {
      border-radius: $border-radius-default;

      @include media-breakpoint-up(lg) {
        width: 70px;
        height: 70px;
        object-fit: cover;
      }
    }
  }
}
</file>
<file name="./client/app/styles/core/_shop.scss" format="scss">
.shop-page {
  .main {
    background-color: $theme-white;
  }

  .shop-toolbar {
    border-radius: $border-radius-primary;
    box-shadow: $box-shadow-primary;
  }
}
</file>
<file name="./client/app/styles/core/_rtl.scss" format="scss">
//  rtl styles
</file>
<file name="./client/app/styles/core/_address.scss" format="scss">
.address-dashboard {
  .a-list {
    .address-box {
      height: 100%;
      border-radius: $border-radius-default;
      box-shadow: $box-shadow-secondary;
      @include transition();

      &:hover {
        background-color: $secondary-bg;
        @include transition();
      }

      .address-icon {
        width: 35px;
        height: 35px;

        @include media-breakpoint-up(lg) {
          width: 50px;
          height: 50px;
        }
      }

      .address-desc {
        @include text-ellipsis(2);
      }
    }
  }
}
</file>
<file name="./client/app/styles/core/page404.scss" format="scss">
.page-404 {
  text-align: center;
  color: $font-custom-color;
  font-size: $font-size-large;
  font-weight: $font-weight-normal;
  min-height: 250px;
  @include center();
}
</file>
<file name="./client/app/styles/core/_components.scss" format="scss">
/* start dropdown confirm styles */
.dropdown-confirm {
  .dropdown-action {
    position: relative;
    border: $border-default;
    border-radius: $border-radius-default;
    background-color: $btn-bg;
    -webkit-transition: $layout-transition-speed;
    transition: $layout-transition-speed;

    &.sm {
      padding: 6px 10px;
      min-width: 100px;

      .btn-text {
        font-size: $font-size-x-small;
      }
    }

    &.md {
      padding: 10px 16px;
      min-width: 135px;
    }

    .btn-text {
      -webkit-transition: $layout-transition-speed;
      transition: $layout-transition-speed;
    }

    &:hover {
      background-color: $secondary-bg;
      color: $font-custom-color !important;

      .btn-text {
        -webkit-transition: $layout-transition-speed;
        transition: $layout-transition-speed;
      }
    }
  }

  .btn-group {
    &.show {
      .dropdown-action {
        background-color: $secondary-bg;
      }
    }
  }

  .dropdown-menu {
    min-width: 250px;
  }

  .nav-link {
    padding: 0;
  }
}
/* end dropdown confirm styles */

/* start pagination styles */
.pagination-box {
  overflow-x: scroll;
  overflow-y: hidden;

  @include hide-scrollbar();

  .page-link {
    white-space: nowrap;
  }
}

.pagination {
  .page-item {
    &.active {
      .page-link {
        color: $white !important;
        background-color: $primary-bg;
      }
    }
  }
}
/* end pagination styles */

/* start slider styles */
.slider {
  .rc-slider-mark-text {
    .fa {
      color: $stars;
    }
  }

  .rc-slider-mark-text-active {
    .fa {
      color: $stars-active;
    }
  }

  .rc-slider-track {
    background-color: $primary-bg;
  }

  .rc-slider-dot-active {
    border-color: $primary-bg;
  }
  .rc-slider-handle-dragging.rc-slider-handle-dragging.rc-slider-handle-dragging {
    box-shadow: none;
    border-color: $primary-bg;
  }

  .rc-slider-handle-click-focused:focus {
    border-color: $primary-bg;
  }

  .rc-slider-handle {
    box-shadow: none;
    border-color: $primary-bg;

    &:active,
    &:hover {
      border-color: $primary-bg;
    }
  }
}
/* end slider styles */
</file>
<file name="./client/app/styles/core/_search.scss" format="scss">
/* start autosuggest styles */
.react-autosuggest__container {
  position: relative;

  .react-autosuggest__input {
    height: 40px;
    padding: 10px 20px;
    border: $border-default;
    border-radius: 4px;
    -webkit-appearance: none;
  }

  .react-autosuggest__input::-ms-clear {
    display: none;
  }

  .react-autosuggest__input--open {
    border-bottom-left-radius: 0;
    border-bottom-right-radius: 0;
  }

  .react-autosuggest__suggestions-container {
    display: none;
  }

  .react-autosuggest__suggestions-container--open {
    display: block;
    position: absolute;
    width: 100%;
    font-weight: 300;
    border-bottom-left-radius: 4px;
    border-bottom-right-radius: 4px;
    z-index: 2;
    border: $border-default;
    background-color: $white;
  }

  .react-autosuggest__suggestions-list {
    margin: 0;
    padding: 0;
    list-style-type: none;
    overflow: auto;
    max-height: 400px;
  }

  .react-autosuggest__suggestion {
    cursor: pointer;
    padding: 10px 20px;
  }

  .react-autosuggest__suggestion--highlighted {
    background-color: $theme-gray;
  }

  .react-autosuggest__section-container--first {
    border-top: 0;
  }

  .react-autosuggest__suggestions-list {
    margin: 0;
    padding: 0;
    list-style-type: none;
    overflow: auto;
    max-height: 400px;
  }

  .react-autosuggest__suggestion-match {
    color: $black;
    font-weight: $font-weight-normal;
  }

  .item-image {
    width: 50px;
    height: 50px;
    border-radius: $border-radius-primary;
  }
}

/* end autosuggest styles */
</file>
<file name="./client/app/styles/core/_fixes.scss" format="scss">
// fixes styles
</file>
<file name="./client/app/styles/core/_newsletter.scss" format="scss">
.newsletter-form {
  p {
    margin: 0;
  }
}

.subscribe {
  .inline-btn-box {
    .input-text-block {
      @include media-breakpoint-between(md, lg) {
        flex-direction: column;

        .input-text {
          border-radius: $border-radius-default;
        }

        .custom-btn-primary {
          margin-top: 10px;
          border-left: $border-default !important;
          border-radius: $border-radius-default !important;
        }
      }
    }
  }
}
</file>
<file name="./client/app/styles/core/_users.scss" format="scss">
.users-dashboard {
  .u-list {
    .user-box {
      border-radius: $border-radius-default;
      box-shadow: $box-shadow-primary;
    }
  }
}
</file>
<file name="./client/app/styles/core/_radio.scss" format="scss">
.radio {
  ul {
    list-style: none;
    margin: 0 0 1px;
    padding: 0;
  }

  li:not(:last-child) {
    margin-bottom: 5px;
  }

  label {
    display: flex;
    align-items: center;
  }

  input[type='radio'] {
    margin: 0 10px 0 0;
  }
}
</file>
<file name="./client/app/styles/core/_variables.scss" format="scss">
// sass variables

// Theme colors
$theme-green: #00acac;
$theme-gray: #f8f9fa;
$theme-bright-gray: #eceef3;
$theme-dark-gray: #cccccc;
$theme-athens-gray: #f1f1f2;
$theme-blue: #2979ff;
$theme-purple: #727cb6;
$theme-white: #f6f7f8;
$theme-light-white: #f0f0f0;
$theme-light-blue-white: #e8f0fe;

$theme-black: #323232;
$theme-light-black: #24292e;
$theme-orange: #e4853f;
$theme-yellow: #ffdd57;
$theme-light-yellow: #fbeeca;
$theme-pink: #ff3860;
$theme-light-blue: #4a68aa;
$theme-bright-red: #fb0000;

$primary-color: #2962ff;
$primary-bg: #2962ff;

$secondary-color: #f8f9fa;
$secondary-bg: #f8f9fa;

$danger-color: #dc3545;
$danger-bg: #dc3545;
$danger-hover-bg: #c3081a;

$dark-bg: $theme-black;
$dark-hover-bg: $black;

$default-color: #758696;
$default-bg: #758696;

// standard colors
$blue: #20a8d8;
$indigo: #6610f2 !default;
$purple: #6f42c1 !default;
$pink: #e83e8c !default;
$red: #ff5454;
$white: #fff;
$orange: #fabb3d;
$yellow: #ffc107 !default;
$green: #79c447;
$gray: #808081;
$teal: #20c997 !default;
$cyan: #67c2ef;
$black: #000;

$font-family: 'Poppins';
$font-family-heading: 'Poppins';
$font-family-body: 'Poppins';
$font-size-x-small: 12px;
$font-size-small: 13px;
$font-size-medium: 14px;
$font-size-large: 15px;
$font-size-x-large: 16px;
$font-size-xx-large: 18px;
$font-size-huge: 20px;
$font-size-x-huge: 24px;
$font-size-heading-xsmall: 14px;
$font-size-heading-small: 16px;
$font-size-heading-medium: 18px;
$font-size-heading-large: 20px;
$font-size-heading-x-large: 24px;
$font-weight-thin: 200;
$font-weight-light: 300;
$font-weight-normal: 400;
$font-weight-medium: 500;
$font-weight-semibold: 600;
$font-weight-bold: 700;

// layout variables
$btn-bg: $white;
$btn-bg-hover: $primary-bg;
$font-color: #65676b;
$font-light-color: #00000026;
$font-custom-color: $theme-black;
$font-subtext-color: $gray;
$font-custom-hover-color: $theme-blue;
$font-hover-color: $black;
$font-focus-color: $black;
$font-heading-color: #262626;
$border-color-default: #e4e6eb;
$border-color-primary: $theme-bright-gray;
$border-hover-color: #ced9de;
$border-focus-color: #bdcbd2;
$separator-color: #e6e5ea;
$dark-overflow-bg: #0006;
$transparent-bg: #3232321f;
$transparent-gray-bg: #f1f3f4f5;
$transparent-white-bg: #f1f1f170;
$hover-bg: #e3e8ea;
$badge: $red;
$stars: #adb5bd;
$stars-active: #ffb302;
$disabled-bg: #d9dbdea1;

$outline-color: #7aacfe;
$validation-color: #dc3545;
$outline-box-shadow: 0 0 0 3px #159ce466;
$box-shadow: 0 0 10px 0 #e6e5ea;
$box-shadow-custom: 0 1px #e6e5ea;
$box-shadow-primary: 0 1px 2px #00000033;
$box-shadow-secondary: 0 0 2px #00000033;
$border-radius-default: 3px;
$border-radius-primary: 5px;
$border-radius-circle: 50px;
$line-height: 1.5;
$letter-spacing: 0.5px;
$border-default: 1px solid $border-color-default;
$border-primary: 1px solid $border-color-primary;
$layout-max-width: 1200px;
$layout-transition-speed: 0.3s !default;
$layout-transition-higher-speed: 0.6s !default;

// icons
$twitter: url('/images/social-icons/twitter.svg');
$pinterest: url('/images/social-icons/pinterest.svg');
$instagram: url('/images/social-icons/instagram.svg');
$facebook: url('/images/social-icons/facebook.svg');

$bars: url('/images/bars.png');
$chevron-down: url('/images/chevron-down.svg');
$close: url('/images/close.svg');
$bag: url('/images/bag.svg');
</file>
<file name="./client/app/styles/core/_category.scss" format="scss">
/* start category dashboard styles */
.category-dashboard {
  .c-list {
    .category-box {
      height: 100%;
      z-index: -1;
      border-radius: $border-radius-default;
      box-shadow: $box-shadow-secondary;
      @include transition();

      &:hover {
        background-color: $secondary-bg;
        @include transition();
      }

      .toggle-box {
        z-index: 1000;
        position: absolute;
        right: 0;
        top: 0;
        height: 25px;
        overflow: hidden;
        // text-indent: 100%;
        white-space: nowrap;

        &::before {
          content: '';
          position: absolute;
          z-index: 1000;
          width: 40px;
          height: 30px;
        }
      }

      .category-desc {
        @include text-ellipsis(2);
      }
    }
  }
}
/* end category dashboard styles */
</file>
<file name="./client/app/styles/core/_header.scss" format="scss">
// header styles
.header-info {
  padding: 10px 0px;
  background-color: $theme-light-black;

  .fa,
  span {
    color: $white;
    font-size: $font-size-medium !important;
    font-weight: $font-weight-normal;
    margin: 0px 5px;
  }
}

.header {
  background-color: $white;
  border-bottom: $border-primary;

  .logo {
    font-size: $font-size-heading-large !important;
    font-weight: $font-weight-normal;
  }
}

.fixed-mobile-header {
  @include media-breakpoint-down(sm) {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    z-index: 998;
  }
}

.top-header {
  // margin-top: 10px;
  // margin-bottom: 10px;
  // height: 95px;
  padding: 16px 0px;

  @include media-breakpoint-up(lg) {
    // height: 60px;

    padding: 22px ​0px;
  }

  .bars-icon {
    &:hover {
      opacity: 0.5;
    }
  }

  .cart-icon {
    position: relative;
    line-height: 100%;

    &:hover {
      opacity: 0.5;
    }
  }

  .fa {
    cursor: pointer;
    color: $theme-dark-gray;
    font-size: $font-size-x-huge !important;
  }

  .col-no-padding {
    @include media-breakpoint-down(sm) {
      padding-right: 15px;
      padding-left: 15px;
    }
  }

  .navbar {
    background-color: $white !important;
    justify-content: flex-end;
    padding: 0;

    @include media-breakpoint-down(sm) {
      padding-top: 0;
      padding-bottom: 0.5rem;
      justify-content: center;
    }

    .cart-icon {
      .bag-icon {
        vertical-align: text-bottom;
      }
    }
  }

  .navbar-nav {
    flex-direction: row;
    @include media-breakpoint-up(md) {
      margin-left: 20px;
    }

    .nav-link {
      padding-top: 0;
      padding-bottom: 0;

      &.active {
        color: $font-hover-color !important;
      }
    }

    a,
    span {
      &:hover {
        color: $font-hover-color !important;
      }
    }

    .dropdown-toggle.nav-link {
      text-transform: capitalize;
    }

    .dropdown-menu {
      &.nav-brand-dropdown {
        padding: 0;
        @include media-breakpoint-down(sm) {
          left: -30px;
          min-width: 270px;
        }
      }
    }

    .nav-item {
      position: relative;
      @include media-breakpoint-down(sm) {
        margin-right: 15px;
      }
    }
  }

  .brand {
    @include flex();
    flex-wrap: wrap;
    align-items: center;
    @include media-breakpoint-down(sm) {
      margin-top: 10px;
      justify-content: center;
    }

    .logo {
      margin: 0px;
      color: $font-custom-color !important;
      @include media-breakpoint-up(md) {
        margin-left: 15px;
      }
    }
  }

  .cart-badge {
    border-radius: 100%;
    font-size: 0.6rem;
    font-weight: 600;
    position: absolute;
    top: -12px;
    right: -14px;
    text-align: center;
    width: 20px;
    height: 20px;
    background-color: $primary-bg;
    color: $white;
    @include flex();
    justify-content: center;
    align-items: center;
  }

  .header-links {
    @include flex();
    flex-wrap: wrap;
    justify-content: space-between;
  }
}

// mini brand
.mini-brand {
  min-width: 270px;
  @include media-breakpoint-up(md) {
    min-width: 500px;
  }

  .min-brand-title {
    border-bottom: $border-primary;
    padding-bottom: 8px;
    margin-bottom: 16px;
  }
}

.mini-brand-list {
  padding: 16px 20px;
  @include media-breakpoint-up(md) {
    padding: 20px 40px;
  }

  .mini-brand-block {
    @include flex();
    flex-wrap: wrap;
    margin-top: 12px;

    .brand-item {
      flex: 100%;
      margin-bottom: 10px;

      @include media-breakpoint-up(md) {
        flex: 50%;
      }

      .brand-link {
        position: relative;
        color: $font-custom-color !important;
        font-size: $font-size-large;
        font-weight: $font-weight-normal;

        &:hover {
          &:after {
            opacity: 1;
            -webkit-transform: translateY(2px);
            -moz-transform: translateY(2px);
            transform: translateY(2px);
          }
        }

        &:after {
          position: absolute;
          top: 100%;
          left: 0;
          width: 100%;
          height: 2px;
          background-color: $primary-bg;
          content: '';
          opacity: 0;
          -webkit-transition: opacity $layout-transition-speed,
            -webkit-transform $layout-transition-speed;
          -moz-transition: opacity $layout-transition-speed,
            -moz-transform $layout-transition-speed;
          transition: opacity $layout-transition-speed,
            transform $layout-transition-speed;
          -webkit-transform: translateY(10px);
          -moz-transform: translateY(10px);
          transform: translateY(10px);
        }
      }
    }
  }
}
</file>
<file name="./client/app/styles/core/utils/_reset.scss" format="scss">
/*
    HTML5 Reset :: style.css
    ----------------------------------------------------------
    We have learned much from/been inspired by/taken code where offered from:
    Eric Meyer                  :: http://meyerweb.com
    HTML5 Doctor                :: http://html5doctor.com
    and the HTML5 Boilerplate   :: http://html5boilerplate.com
-------------------------------------------------------------------------------*/

/* Let's default this puppy out
-------------------------------------------------------------------------------*/

html,
body,
body div,
span,
object,
iframe,
h1,
h2,
h3,
h4,
h5,
h6,
p,
blockquote,
pre,
abbr,
address,
cite,
code,
del,
dfn,
em,
img,
ins,
kbd,
q,
samp,
small,
strong,
sub,
sup,
var,
b,
i,
dl,
dt,
dd,
ol,
ul,
li,
fieldset,
form,
label,
legend,
table,
caption,
tbody,
tfoot,
thead,
tr,
th,
td,
article,
aside,
figure,
footer,
header,
menu,
nav,
section,
time,
mark,
audio,
video,
details,
summary {
  background: transparent;
  border: 0;
  font-size: 100%;
  font-weight: normal;
  margin: 0;
  padding: 0;
  vertical-align: baseline;
}

article,
aside,
figure,
footer,
header,
nav,
section,
details,
summary {
  display: block;
}

/* Handle box-sizing while better addressing child elements:
   http://css-tricks.com/inheriting-box-sizing-probably-slightly-better-best-practice/ */
html {
  box-sizing: border-box;
}

*,
*:before,
*:after {
  box-sizing: inherit;
}

/* consider resetting the default cursor: https://gist.github.com/murtaugh/5247154 */

/* Responsive images and other embedded objects
*/
img,
object,
embed {
  max-width: 100%;
}

/*
   Note: keeping IMG here will cause problems if you're using foreground images as sprites.
     In fact, it *will* cause problems with Google Maps' controls at small size.
    If this is the case for you, try uncommenting the following:
#map img {
        max-width: none;
}
*/

/* force a vertical scrollbar to prevent a jumpy page */
html {
  overflow-y: scroll;
}

/* we use a lot of ULs that aren't bulleted.
    don't forget to restore the bullets within content. */
ul {
  list-style: none;
}

blockquote,
q {
  quotes: none;
}

blockquote:before,
blockquote:after,
q:before,
q:after {
  content: '';
  content: none;
}

a {
  background: transparent;
  font-size: 100%;
  margin: 0;
  padding: 0;
  vertical-align: baseline;
}

del {
  text-decoration: line-through;
}

abbr[title],
dfn[title] {
  border-bottom: 1px dotted #000;
  cursor: help;
}

/* tables still need cellspacing="0" in the markup */
table {
  border-collapse: collapse;
  border-spacing: 0;
}

th {
  font-weight: bold;
  vertical-align: bottom;
}

td {
  font-weight: normal;
  vertical-align: top;
}

hr {
  border: 0;
  border-top: 1px solid #ccc;
  display: block;
  height: 1px;
  margin: 1em 0;
  padding: 0;
}

input,
select {
  vertical-align: middle;
}

pre {
  white-space: pre; /* CSS2 */
  white-space: pre-wrap; /* CSS 2.1 */
  white-space: pre-line; /* CSS 3 (and 2.1 as well, actually) */
  word-wrap: break-word; /* IE */
}

input[type='radio'] {
  vertical-align: text-bottom;
}

input[type='checkbox'] {
  vertical-align: bottom;
}

.ie7 input[type='checkbox'] {
  vertical-align: baseline;
}

.ie6 input {
  vertical-align: text-bottom;
}

select,
input,
textarea {
  font: 99% sans-serif;
}

table {
  font: 100%;
  font-size: inherit;
}

small {
  font-size: 85%;
}

strong {
  font-weight: bold;
}

td,
td img {
  vertical-align: top;
}

/* Make sure sup and sub don't mess with your line-heights http://gist.github.com/413930 */
sub,
sup {
  font-size: 75%;
  line-height: 0;
  position: relative;
}

sup {
  top: -0.5em;
}

sub {
  bottom: -0.25em;
}

/* standardize any monospaced elements */
pre,
code,
kbd,
samp {
  font-family: monospace, sans-serif;
}

/* hand cursor on clickable elements */
.clickable,
label,
input[type='button'],
input[type='submit'],
input[type='file'],
button {
  cursor: pointer;
}

/* Webkit browsers add a 2px margin outside the chrome of form elements */
button,
input,
select,
textarea {
  margin: 0;
}

/* make buttons play nice in IE */
button,
input[type='button'] {
  overflow: visible;
  width: auto;
}

/* scale images in IE7 more attractively */
.ie7 img {
  -ms-interpolation-mode: bicubic;
}

/* prevent BG image flicker upon hover
   (commented out as usage is rare, and the filter syntax messes with some pre-processors)
.ie6 html {filter: expression(document.execCommand("BackgroundImageCache", false, true));}
*/

/* let's clear some floats */
.clearfix:before,
.clearfix:after {
  content: '\0020';
  display: block;
  height: 0;
  overflow: hidden;
}

.clearfix:after {
  clear: both;
}

.clearfix {
  zoom: 1;
}
</file>
<file name="./client/app/styles/core/utils/_fonts.scss" format="scss">
// @import '~@fontsource/poppins/index.css';
@import '~@fontsource/poppins/300.css';
@import '~@fontsource/poppins/400.css';
@import '~@fontsource/poppins/500.css';
@import '~@fontsource/poppins/600.css';
@import '~@fontsource/poppins/700.css';
</file>
<file name="./client/app/styles/core/_mixins.scss" format="scss">
// transition mixin
@mixin transition($speed: $layout-transition-speed) {
  -webkit-transition: all $speed ease;
  -moz-transition: all $speed ease;
  -o-transition: all $speed ease;
  transition: all $speed ease;
}

// transform mixin
@mixin transform($deg) {
  -webkit-transform: scale($deg, $deg);
  -ms-transform: scale($deg, $deg);
  transform: scale($deg, $deg);
}

// flexbox
@mixin flex() {
  display: -webkit-box;
  display: -moz-box;
  display: -ms-flexbox;
  display: -webkit-flex;
  display: flex;
}

// flex wrap
@mixin flex-wrap($value) {
  -webkit-flex-wrap: $value;
  -ms-flex-wrap: $value;
  flex-wrap: $value;
}

@mixin center() {
  @include flex();
  justify-content: center;
  align-items: center;
}

// width fit
@mixin width-fit() {
  width: intrinsic; /* Safari/WebKit uses a non-standard name */
  width: -moz-max-content; /* Firefox/Gecko */
  width: -webkit-max-content; /* Chrome */
}

// icon styles
@mixin icon($icon, $width: null, $height: null) {
  background-image: $icon;
  background-position: center;
  background-repeat: no-repeat;
  cursor: pointer;
  height: $width;
  width: $height;
}

// badge styles
@mixin badge() {
  border-radius: 100%;
  font-size: 0.6rem;
  font-weight: 600;
  height: 16px;
  position: absolute;
  right: -10px;
  text-align: center;
  top: -7px;
  width: 16px;
  background-color: $primary-bg;
  color: $white;
  @include flex();
  justify-content: center;
  align-items: center;
}

// text ellipsis ...
@mixin text-ellipsis($numLines: 1, $lineHeight: 1.412) {
  overflow: hidden;
  text-overflow: -o-ellipsis-lastline;
  text-overflow: ellipsis;
  display: block;
  /* autoprefixer: off */
  display: -webkit-box;
  -webkit-line-clamp: $numLines;
  -webkit-box-orient: vertical;
  max-height: $numLines * $lineHeight + unquote('em');
}

@mixin text-truncate() {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

// dark overflow
@mixin dark-overflow {
  background-color: $dark-overflow-bg;
  cursor: pointer;
  height: 100%;
  left: 0;
  position: fixed;
  top: 0;
  width: 100%;
  z-index: 999;
}

@mixin appearance($value: none) {
  -webkit-appearance: $value;
  -moz-appearance: $value;
  -ms-appearance: $value;
  -o-appearance: $value;
  appearance: $value;
}

@mixin sr-only() {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  border: 0;
}

@mixin placeholder {
  ::-webkit-input-placeholder {
    @content;
  }

  ::-moz-placeholder {
    @content;
  }

  :-moz-placeholder {
    @content;
  }

  :-ms-input-placeholder {
    @content;
  }
}

@mixin hide-scrollbar {
  -ms-overflow-style: none; /* IE and Edge */
  scrollbar-width: none; /* Firefox */

  &::-webkit-scrollbar {
    display: none; /* Hide scrollbar for Chrome, Safari and Opera */
  }
}
</file>
<file name="./client/app/styles/core/_overrides.scss" format="scss">
// overrides styles

// start bootstrap overrides
.form-control {
  height: auto;

  &:focus {
    box-shadow: $box-shadow;
  }
}

.dropdown-item {
  font-weight: $font-weight-normal !important;
  padding: 12px;
  border-radius: $border-radius-default;

  &:focus {
    outline: none;
  }

  &:active {
    background-color: $secondary-bg;
  }

  &.active {
    background-color: $secondary-bg;
    font-weight: $font-weight-normal !important;
  }

  a {
    display: block;
    padding: 5px 15px;
  }
}

.dropdown-menu {
  position: absolute !important;
  z-index: 1001;
  border: none;
  box-shadow: $box-shadow;
  padding: 10px;
}

.dropdown,
.btn-group {
  &.show {
    .nav-link {
      .dropdown-caret {
        transform: rotate(180deg);
        -webkit-transition: $layout-transition-speed;
        transition: $layout-transition-speed;
      }
    }
  }

  .nav-link {
    .dropdown-caret {
      font-size: $font-size-x-small !important;
      color: $theme-dark-gray;
      margin-left: 5px;
      -webkit-transition: $layout-transition-speed;
      transition: $layout-transition-speed;
    }
  }
}

.btn {
  &:hover {
    color: $white !important;
  }
  &:focus {
    box-shadow: none;
  }
}

hr {
  border-color: $border-color-primary;
}

.lead {
  font-size: $font-size-medium;
}
// end bootstrap overrides

// start react-notification-system-redux overrides
.notification {
  .notification-title {
    font-weight: $font-weight-normal !important;
  }
}
// end react-notification-system-redux overrides

// start carousel styles
.carousel-container {
  .react-multiple-carousel__arrow {
    z-index: 900;
  }

  .carousel-dot-list-style {
    .react-multi-carousel-dot {
      button {
        border-color: $border-color-primary;

        &:focus {
          outline: none;
        }
      }
    }

    .react-multi-carousel-dot--active {
      button {
        background-color: $secondary-bg;
      }
    }
  }
}

// end carousel styles

// start popover styles
.popover {
  border-color: $border-color-default;
  font-family: $font-family;
}

.popover-header {
  font-size: $font-size-medium !important;
  background-color: $secondary-bg;
}
// end popover styles
</file>
<file name="./client/app/styles/core/_spinner.scss" format="scss">
.spinner-container {
  height: 100%;
  top: 0;
  width: 100%;
  left: 0;
}

.spinner-container {
  &.overlay {
    z-index: 3000;
  }

  &.backdrop {
    background-color: $transparent-white-bg;
  }
}

.spinner {
  bottom: 0;
  left: 0;
  right: 0;
  top: 25%;
  z-index: 1022;
  width: 40px;
  height: 40px;
  margin: 100px auto;
  background-color: $theme-light-blue;
  border-radius: 100%;
  -webkit-animation: sk-scaleout 1s infinite ease-in-out;
  animation: sk-scaleout 1s infinite ease-in-out;
}

@-webkit-keyframes sk-scaleout {
  0% {
    -webkit-transform: scale(0);
  }
  100% {
    -webkit-transform: scale(1);
    opacity: 0;
  }
}

@keyframes sk-scaleout {
  0% {
    -webkit-transform: scale(0);
    transform: scale(0);
  }
  100% {
    -webkit-transform: scale(1);
    transform: scale(1);
    opacity: 0;
  }
}
</file>
<file name="./client/app/styles/core/_order.scss" format="scss">
.order-dashboard {
  .order-list {
    .order-details {
      @include flex();
      flex-direction: column;
      height: 100%;
    }

    .order-box {
      border-radius: $border-radius-default;
      box-shadow: $box-shadow-secondary;

      .order-first-item {
        align-self: center;

        .item-image {
          border-top-right-radius: $border-radius-default;
          border-top-left-radius: $border-radius-default;

          @include media-breakpoint-up(lg) {
            border-radius: $border-radius-default;
          }

          @include media-breakpoint-up(lg) {
            width: 90px;
            height: 90px;
          }
        }
      }
    }
  }
}

/* start order success styles */
.order-success {
  .order-message {
    text-align: center;
  }

  .order-success-actions {
    text-align: center;

    .btn-link {
      margin-right: 10px;

      @include media-breakpoint-down(xs) {
        width: 100%;
        margin-bottom: 10px;
      }
    }
  }
}
/* end order success styles */

/* start order meta styles */
.order-meta {
  .title {
    border-bottom: $border-primary;
    padding-bottom: 8px;
    margin-bottom: 16px;
  }

  p {
    text-transform: capitalize;
    margin-bottom: 5px;
  }
}
/* end order meta styles */

/* start order items styles */
.order-items {
  h2 {
    border-bottom: $border-primary;
    padding-bottom: 8px;
    margin-bottom: 16px;
  }

  .item {
    &:last-child {
      .order-item-box {
        border-bottom: none;
        padding-bottom: 0;
        margin-bottom: 0;
      }
    }
  }

  .order-item-box {
    border-bottom: $border-primary;
    padding-bottom: 16px;
    margin-bottom: 16px;

    @include media-breakpoint-down(xs) {
      .dropdown-confirm {
        .btn-group {
          width: 100%;

          .nav-link {
            width: 100%;
            text-align: center;
          }
        }
      }
    }

    @include media-breakpoint-up(md) {
      .box {
        width: 50%;
      }
    }

    .dropdown-confirm {
      &.admin {
        .dropdown-menu {
          min-width: 150px;
        }
      }
    }

    .item-details {
      max-width: 200px;
    }

    .item-image {
      width: 80px;
      border-radius: $border-radius-default;
    }
  }

  p {
    margin-bottom: 0;
  }

  .price {
    font-size: $font-size-medium;
  }
}
/* end order items styles */

/* start order summary styles */
.order-summary {
  border: $border-primary;

  h2 {
    border-bottom: $border-primary;
    padding-bottom: 8px;
    margin-bottom: 16px;
  }
}
/* end order summary styles */

.order-status {
  color: $default-color !important;
}

/* start order common styles */
.order-label {
  font-weight: $font-weight-medium;
  color: $font-custom-color;
}
/* end order common styles */
</file>
<file name="./client/app/styles/core/_dashboard.scss" format="scss">
.panel-body {
  // padding: 10px;

  @include media-breakpoint-down(sm) {
    margin-top: 20px;
  }
}

.panel-sidebar {
  .panel-title,
  .menu-panel {
    margin: 0;
    padding: 10px 0px;
    text-align: center;
    border: $border-primary;
    border-bottom: none;
  }

  .menu-panel {
    &.collapse {
      border-bottom: $border-primary;

      &:hover {
        background-color: $theme-gray;
      }
    }
  }

  .panel-title {
    @include media-breakpoint-down(sm) {
      display: none;
    }
  }

  .navbar {
    padding: 0px;
  }

  .menu-panel {
    display: none;
    width: 100%;
    @include media-breakpoint-down(sm) {
      display: block;
      cursor: pointer;
    }

    &:hover {
      background-color: transparent;
    }

    .btn-text {
      font-size: $font-size-heading-xsmall !important;
      font-weight: $font-weight-normal;
    }
  }

  .panel-links {
    width: 100%;
    text-align: center;
    margin-bottom: 0;

    li {
      border-top: $border-primary;
      border-right: $border-primary;
      border-left: $border-primary;

      &:hover {
        a {
          color: $font-custom-color !important;
        }
      }

      &:last-child {
        border-bottom: $border-primary;
      }

      a {
        display: block;
        padding: 10px 0px;
        text-transform: capitalize;
        color: $font-custom-color !important;
        font-weight: $font-weight-normal;

        &.active-link {
          font-weight: $font-weight-medium;
          background-color: $white;
        }
      }
    }
  }
}
</file>
<file name="./client/app/styles/core/_login.scss" format="scss">
// (Login, SignUp, forgetPassword,resetPassword) => Styles
.signup-form {
  .checkbox {
    margin-bottom: 20px;
  }
}

.signup-provider {
  @include flex();
  flex-direction: column;
  justify-content: center;
  align-items: center;
  height: 100%;
  cursor: pointer;
}

.google-btn,
.facebook-btn {
  @include flex();
  -ms-flex-wrap: wrap;
  -webkit-flex-wrap: wrap;
  flex-wrap: wrap;
  align-items: center;
  justify-content: center;
  padding: 12px 20px;
  width: 300px;
  max-width: 350px;
  border: $border-primary;
  border-radius: $border-radius-default;
  @include media-breakpoint-down(sm) {
    width: 100%;
    max-width: unset;
  }

  .btn-text {
    margin-left: 5px;
  }

  .google-icon,
  .facebook-icon {
    width: 30px;
    height: 30px;
  }
}
</file>
<file name="./client/app/styles/core/_account.scss" format="scss">
.account {
  .info {
    margin-bottom: 10px;
    @include flex();
    // flex-wrap: wrap;
    justify-content: flex-start;
    flex-direction: row;
    align-items: center;
    @include media-breakpoint-down(xs) {
      flex-direction: column;
      align-items: normal;
    }

    .desc {
      flex: 1;
      @include media-breakpoint-down(xs) {
        @include flex();
        justify-content: space-between;
        align-items: center;
      }

      .provider-email {
        text-transform: capitalize;
      }
    }

    p,
    span {
      margin: 0;
      display: inline;
    }
  }
}
</file>
<file name="./client/app/styles/core/_footer.scss" format="scss">
// footer styles
.footer {
  flex-shrink: 0;
  border-top: $border-default;
}

.footer-content {
  @include flex();
  padding-top: 20px;
  margin: 0 auto;
  @include media-breakpoint-down(sm) {
    flex-direction: column;
  }
}

.footer-block {
  width: 100%;
  margin-right: 16px;
  border-right: $border-primary;
  padding-top: 20px;

  &:last-child {
    margin-right: 0;
  }

  @include media-breakpoint-down(sm) {
    text-align: center;
    margin: 10px 0px;
    border-right: none;
    border-bottom: $border-primary;
    padding: 20px 0px;
  }

  &:last-child {
    border-right: 0;
    border-bottom: 0;
  }

  .block-title {
    padding-bottom: 10px;
  }

  .footer-link {
    padding-bottom: 4px;

    a {
      &:hover {
        text-decoration: underline !important;
      }
    }
  }
}

/*
 * Social Icons
 */

.footer-social-item {
  text-align: center;
  span,
  a {
    display: inline-block;
    vertical-align: top;

    &:hover {
      opacity: 0.8;
    }
  }

  li {
    padding-bottom: 8px;
    margin: 0 auto;
    display: inline-block;
    @include media-breakpoint-down(sm) {
      margin: 0 4px;
    }

    a {
      margin-left: 10px;
      @include media-breakpoint-down(sm) {
        display: block;
        margin-left: 0px;
      }
    }
  }

  .facebook-icon {
    @include icon($facebook, 40px, 40px);
    background-size: 100%;
  }

  .instagram-icon {
    @include icon($instagram, 40px, 40px);
    background-size: 100%;
    border-radius: 50%;
  }

  .pinterest-icon {
    @include icon($pinterest, 40px, 40px);
    background-size: 100%;
  }

  .twitter-icon {
    @include icon($twitter, 40px, 40px);
    background-size: 100%;
  }
}

/*
 * Copyright
 */

.footer-copyright {
  text-align: center;
  padding: 16px 0px;
}
</file>
<file name="./client/app/styles/core/_table.scss" format="scss">
.table-section {
  .search {
    margin: 15px 0px;

    .search-label {
      width: 100%;
    }
  }

  .react-bootstrap-table {
    .table {
      overflow-x: scroll;
      display: block;
      margin: 20px 0px;
      color: $font-custom-color;

      td,
      th {
        white-space: nowrap;
        text-overflow: unset;
        overflow-wrap: break-word;
        width: 100%;
      }
    }
  }
}
</file>
<file name="./client/app/styles/core/_cart.scss" format="scss">
// mini cart
.mini-cart {
  visibility: hidden;
  position: fixed;
  top: 0;
  right: -100%;
  background-color: $white;
  height: 100%;
  width: 470px;
  z-index: 1000;
  // -webkit-box-shadow: $box-shadow;
  // box-shadow: $box-shadow;
  @include transition($layout-transition-higher-speed);

  @include media-breakpoint-down(xs) {
    width: 88%;
    top: 0;
  }
}

// show hidden cart popup
.mini-cart-open {
  .mini-cart {
    visibility: visible;
    right: 0;
    @include transition($layout-transition-higher-speed);
  }

  .dark-overflow {
    @include dark-overflow();
    @include media-breakpoint-down(xs) {
      width: 100%;
      top: 0;
    }
  }
}

.cart {
  height: 100%;
  display: flex;
  flex-direction: column;

  .cart-body {
    flex: 1;
    overflow-y: auto;
    overflow-x: hidden;
    max-height: 100%;
    background-color: $white;
  }

  .item-box {
    padding: 10px;
    margin-bottom: 5px;
    border-bottom: $border-default;

    &:last-child {
      border-bottom: none;
    }

    .value {
      color: $font-custom-color;
      font-weight: $font-weight-normal;
      font-size: $font-size-xx-large;
    }

    .item-details {
      .item-image {
        width: 80px;
        height: 80px;
        object-fit: cover;
        border-radius: $border-radius-default;
      }

      .icon-trash {
        color: $font-custom-color;
        font-size: $font-size-xx-large;
        cursor: pointer;
      }

      p {
        margin-bottom: 0;
      }
    }
  }

  .cart-header {
    border-bottom: $border-default;
    text-align: right;
    padding-right: 5px;
    align-items: center;
    justify-content: flex-end;
    height: 50px;
    @include flex();
  }

  .empty-cart {
    height: 100%;
    @include flex();
    align-items: center;
    justify-content: center;
    flex-direction: column;

    .bag-icon {
      width: 50px;
      height: 50px;
    }

    p {
      font-weight: $font-weight-normal;
      margin-top: 12px;
    }
  }

  .cart-checkout {
    background-color: $white;
    border-top: $border-default;

    .cart-summary {
      padding: 10px;
      background-color: $theme-white;

      p {
        margin-bottom: 0;
      }
    }
  }
}

/* start cart common styles */
.summary-item {
  .summary-label {
    color: $font-custom-color;
    font-weight: $font-weight-normal;
    text-transform: capitalize;
  }

  .summary-value {
    color: $font-custom-color;
    font-weight: $font-weight-medium;
  }
}
/* end cart common styles */
</file>
<file name="./client/app/styles/core/_brand.scss" format="scss">
.brand-dashboard {
  .b-list {
    .brand-box {
      height: 100%;
      border-radius: $border-radius-default;
      box-shadow: $box-shadow-secondary;
      @include transition();

      &:hover {
        background-color: $secondary-bg;
        @include transition();
      }

      .brand-desc {
        @include text-ellipsis(2);
      }
    }
  }
}

.brand-list {
  .brand-box {
    height: 100%;
    padding: 10px;
    border: $border-default;
    border-radius: $border-radius-default;
    @include transition();

    .brand-link {
      display: block;
    }

    &:hover {
      background-color: $secondary-bg;
      border-color: $border-hover-color;
      @include transition();
    }

    .brand-desc {
      @include text-ellipsis(2);
    }
  }
}
</file>
<file name="./client/app/styles/core/_wishlist.scss" format="scss">
/* start wishlist dashboard styles */
.wishlist-dashboard {
  .w-list {
    .wishlist-box {
      height: 110px;
      max-height: 110px;
      position: relative;
      border-radius: $border-radius-default;
      box-shadow: $box-shadow-secondary;
      @include transition();

      &:hover {
        background-color: $secondary-bg;
        @include transition();
      }

      .remove-wishlist-box {
        position: absolute;
        top: -10px;
        right: -13px;
        z-index: 1;
      }

      .item-image {
        width: 110px;
        min-width: 110px;
        height: 110px;
        object-fit: cover;
        border-radius: $border-radius-default;
      }

      .price {
        color: $font-custom-color;
        font-weight: $font-weight-normal;
        font-size: $font-size-medium;
      }
    }
  }
}
/* end wishlist dashboard styles */

/* start add to wishlist styles */
.add-to-wishlist {
  .heart-icon {
    cursor: pointer;
    overflow: visible;
    width: 40px;
    height: 40px;

    #heart {
      transform-origin: center;
      animation: animateHeartOut 0.3s linear forwards;
    }
    #main-circ {
      transform-origin: 29.5px 29.5px;
    }
  }

  .input-checkbox {
    &:checked + label .heart-icon {
      #heart {
        transform: scale(0.2);
        fill: red;
        animation: animateHeart 0.3s linear forwards 0.25s;
      }
      #main-circ {
        transition: all 2s;
        animation: animateCircle 0.3s linear forwards;
        opacity: 1;
      }
      #grp1 {
        opacity: 1;
        transition: 0.1s all 0.3s;
      }

      #grp1 #oval1 {
        transform: scale(0) translate(0, -30px);
        transform-origin: 0 0 0;
        transition: 0.5s transform 0.3s;
      }

      #grp1 #oval2 {
        transform: scale(0) translate(10px, -50px);
        transform-origin: 0 0 0;
        transition: 1.5s transform 0.3s;
      }
      #grp2 {
        opacity: 1;
        transition: 0.1s all 0.3s;
      }
      #grp2 #oval1 {
        transform: scale(0) translate(30px, -15px);
        transform-origin: 0 0 0;
        transition: 0.5s transform 0.3s;
      }

      #grp2 #oval2 {
        transform: scale(0) translate(60px, -15px);
        transform-origin: 0 0 0;
        transition: 1.5s transform 0.3s;
      }

      #grp3 {
        opacity: 1;
        transition: 0.1s all 0.3s;
      }

      #grp3 #oval1 {
        transform: scale(0) translate(30px, 0px);
        transform-origin: 0 0 0;
        transition: 0.5s transform 0.3s;
      }

      #grp3 #oval2 {
        transform: scale(0) translate(60px, 10px);
        transform-origin: 0 0 0;
        transition: 1.5s transform 0.3s;
      }

      #grp4 {
        opacity: 1;
        transition: 0.1s all 0.3s;
      }

      #grp4 #oval1 {
        transform: scale(0) translate(30px, 15px);
        transform-origin: 0 0 0;
        transition: 0.5s transform 0.3s;
      }

      #grp4 #oval2 {
        transform: scale(0) translate(40px, 50px);
        transform-origin: 0 0 0;
        transition: 1.5s transform 0.3s;
      }

      #grp5 {
        opacity: 1;
        transition: 0.1s all 0.3s;
      }

      #grp5 #oval1 {
        transform: scale(0) translate(-10px, 20px);
        transform-origin: 0 0 0;
        transition: 0.5s transform 0.3s;
      }

      #grp5 #oval2 {
        transform: scale(0) translate(-60px, 30px);
        transform-origin: 0 0 0;
        transition: 1.5s transform 0.3s;
      }

      #grp6 {
        opacity: 1;
        transition: 0.1s all 0.3s;
      }

      #grp6 #oval1 {
        transform: scale(0) translate(-30px, 0px);
        transform-origin: 0 0 0;
        transition: 0.5s transform 0.3s;
      }

      #grp6 #oval2 {
        transform: scale(0) translate(-60px, -5px);
        transform-origin: 0 0 0;
        transition: 1.5s transform 0.3s;
      }

      #grp7 {
        opacity: 1;
        transition: 0.1s all 0.3s;
      }

      #grp7 #oval1 {
        transform: scale(0) translate(-30px, -15px);
        transform-origin: 0 0 0;
        transition: 0.5s transform 0.3s;
      }

      #grp7 #oval2 {
        transform: scale(0) translate(-55px, -30px);
        transform-origin: 0 0 0;
        transition: 1.5s transform 0.3s;
      }
      #grp2 {
        opacity: 1;
        transition: 0.1s opacity 0.3s;
      }

      #grp3 {
        opacity: 1;
        transition: 0.1s opacity 0.3s;
      }

      #grp4 {
        opacity: 1;
        transition: 0.1s opacity 0.3s;
      }

      #grp5 {
        opacity: 1;
        transition: 0.1s opacity 0.3s;
      }

      #grp6 {
        opacity: 1;
        transition: 0.1s opacity 0.3s;
      }

      #grp7 {
        opacity: 1;
        transition: 0.1s opacity 0.3s;
      }
    }
  }

  @keyframes animateCircle {
    40% {
      transform: scale(10);
      opacity: 1;
      fill: #dd4688;
    }
    55% {
      transform: scale(11);
      opacity: 1;
      fill: #d46abf;
    }
    65% {
      transform: scale(12);
      opacity: 1;
      fill: #cc8ef5;
    }
    75% {
      transform: scale(13);
      opacity: 1;
      fill: transparent;
      stroke: #cc8ef5;
      stroke-width: 0.5;
    }
    85% {
      transform: scale(17);
      opacity: 1;
      fill: transparent;
      stroke: #cc8ef5;
      stroke-width: 0.2;
    }
    95% {
      transform: scale(18);
      opacity: 1;
      fill: transparent;
      stroke: #cc8ef5;
      stroke-width: 0.1;
    }
    100% {
      transform: scale(19);
      opacity: 1;
      fill: transparent;
      stroke: #cc8ef5;
      stroke-width: 0;
    }
  }

  @keyframes animateHeart {
    0% {
      transform: scale(0.2);
    }
    40% {
      transform: scale(1.2);
    }
    100% {
      transform: scale(1);
    }
  }

  @keyframes animateHeartOut {
    0% {
      transform: scale(1.4);
    }
    100% {
      transform: scale(1);
    }
  }
}
/* end add to wishlist styles */
</file>
<file name="./client/app/styles/core/_checkout.scss" format="scss">
.easy-checkout {
  border-top: $border-default;

  .checkout-actions {
    padding: 10px;
    text-align: center;

    .input-btn {
      margin-right: 10px;

      @include media-breakpoint-down(xs) {
        width: 100%;
        margin-bottom: 10px;
      }
    }
  }
}
</file>
<file name="./client/app/styles/core/_utils.scss" format="scss">
// utils styles

/* start not found styles */
.not-found {
  text-align: center;
  // text-transform: capitalize;
  font-weight: $font-weight-medium;
  color: $font-custom-color;
}
/* end not found styles */

.message-box {
  p {
    margin: 0;
    text-transform: capitalize;
  }
}

.col-no-padding {
  padding: 0;
}

.flex-row {
  @include media-breakpoint-up(md) {
    margin-right: -8px;
    margin-left: -8px;
  }
}

.flex-sm-row {
  margin-right: -8px;
  margin-left: -8px;
}

.flex-1 {
  flex: 1;
}

.fw-light {
  font-weight: $font-weight-light;
}

.fw-normal {
  font-weight: $font-weight-normal;
}

.fw-medium {
  font-weight: $font-weight-medium;
}

.fw-semi-bold {
  font-weight: $font-weight-semibold;
}

.fw-bold {
  font-weight: $font-weight-bold;
}

.fs-12 {
  font-size: 12px;
}

.fs-14 {
  font-size: 14px;
}

.fs-16 {
  font-size: 16px;
}

.text-gray {
  color: $gray;
}

.text-black {
  color: $black;
}

.text-green {
  color: $green;
}

.text-primary {
  color: $primary-color !important;
}

.text-secondary {
  color: $secondary-color !important;
}

.bg-secondary {
  background-color: $secondary-bg !important;
}

.text-uppercase {
  text-transform: uppercase;
}

.word-break-all {
  word-break: break-all;
}

.one-line-ellipsis {
  display: -webkit-box;
  -webkit-line-clamp: 1;
  -webkit-box-orient: vertical;
  overflow: hidden;
  text-overflow: ellipsis;
}

.two-line-ellipsis {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  text-overflow: ellipsis;
}

.three-line-ellipsis {
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
  text-overflow: ellipsis;
}

// .text-truncate {
//   @include text-truncate();
// }

.w-lg-auto {
  @include media-breakpoint-up(lg) {
    width: auto !important;
  }
}

.box-shadow-primary {
  box-shadow: $box-shadow-primary;
}

.box-link {
  @include transition();

  &:hover,
  &:focus {
    box-shadow: none !important;
    color: $font-custom-color !important;
    background-color: $secondary-bg;
    @include transition();
  }
}

// default link
.default-link {
  color: $font-custom-color !important;
  font-weight: $font-weight-normal;

  &:hover {
    text-decoration: underline !important;
  }
}

.redirect-link {
  color: $primary-color !important;
  font-weight: $font-weight-normal;
  text-transform: capitalize;
}

.desktop-hidden {
  display: none;

  @include media-breakpoint-down(sm) {
    display: block;
  }
}

.fa {
  font-size: $font-size-small;
}

.drawer-backdrop {
  @include transition();

  &.dark-overflow {
    @include transition();
  }
}

.avatar {
  border-radius: 50%;
}

.avatar-sm {
  width: 60px;
  height: 60px;
}
</file>
<file name="./client/app/styles/core/core.scss" format="scss">
// Import core styles
@import 'variables';
@import 'mixins';

// layout
@import 'layout';
@import 'utils';

// overrides
@import 'overrides';

// bug fixes
@import 'fixes';

// Right-to-left
@import 'rtl';

// components
@import 'components';
@import 'footer';
@import 'header';
@import 'input';
@import 'button';
@import 'checkbox';
@import 'switch';
@import 'spinner';
@import 'cart';
@import 'newsletter';
@import 'login';
@import 'page404';
@import 'homepage';
@import 'dashboard';
@import 'account';
@import 'users';
@import 'product';
@import 'category';
@import 'brand';
@import 'address';
@import 'subpage';
@import 'table';
@import 'menu';
@import 'shop';
@import 'checkout';
@import 'merchant';
@import 'coming-soon';
@import 'order';
@import 'review';
@import 'wishlist';
@import 'share';
@import 'search';
@import 'radio';
@import 'badge';
@import 'support';
</file>
<file name="./client/app/styles/core/_subpage.scss" format="scss">
.sub-page {
  .subpage-header {
    @include flex();
    justify-content: space-between;
    align-items: center;
    border-bottom: $border-primary;
    padding-bottom: 16px;

    h2 {
      margin: 0;
    }

    .fa-ellipsis-h {
      padding: 6px 8px;
    }

    .fa-ellipsis-v {
      padding: 6px 15px;
    }

    .fa {
      cursor: pointer;
      border-radius: 50%;
      background-color: $transparent-gray-bg;
      color: $theme-dark-gray;
      -webkit-text-stroke: 1px $transparent-gray-bg;
      font-size: $font-size-huge !important;
      animation: vibrate 0.42s cubic-bezier(0.36, 0.07, 0.19, 0.97) both;
      animation-iteration-count: 1;
      transform: translate3d(0, 0, 0);
      backface-visibility: hidden;
      perspective: 1000px;

      &:hover {
        opacity: 0.8;
        // color: $white;
      }
    }

    // .back {
    //   &:hover {
    //     color: $theme-blue;
    //   }

    //   .fa {
    //     &::before {
    //       margin-right: 5px;
    //     }
    //   }
    // }
  }

  .subpage-body {
    margin: 20px 0px;
  }
}

@keyframes vibrate {
  10%,
  90% {
    transform: translate3d(-1px, 0, 0);
  }

  20%,
  80% {
    transform: translate3d(2px, 0, 0);
  }

  30%,
  50%,
  70% {
    transform: translate3d(-4px, 0, 0);
  }

  40%,
  60% {
    transform: translate3d(4px, 0, 0);
  }
}
</file>
<file name="./client/app/styles/core/_merchant.scss" format="scss">
.sell {
  .agreement-banner-text {
    background-color: $theme-white;
    padding: 30px 16px 30px;
    border-radius: $border-radius-primary;
  }

  .agreement-banner {
    margin: 0 auto;
    width: 250px;

    @include media-breakpoint-up(md) {
      width: 300px;
    }
  }
}

.merchant-dashboard {
  .merchant-box {
    border-radius: $border-radius-default;
    box-shadow: $box-shadow-secondary;
  }
}
</file>
<file name="./client/app/styles/style.scss" format="scss">
/* MERN Theme */

// Import utilities
@import 'core/utils/fonts';
@import 'core/utils/reset';

// Import Bootstrap source files
@import 'node_modules/bootstrap/scss/bootstrap';

// Import core styles
@import 'core/core';

// Import custom styles
@import 'custom';
</file>
<file name="./client/app/styles/_custom.scss" format="scss">
// Here you can add other styles
</file>
<file name="./client/app/utils/error.js" format="js">
/**
 *
 * error.js
 * This is a generic error handler, it receives the error returned from the server and present it on a pop up
 */

import { error } from 'react-notification-system-redux';

import { signOut } from '../containers/Login/actions';

const handleError = (err, dispatch, title = '') => {
  const unsuccessfulOptions = {
    title: `${title}`,
    message: ``,
    position: 'tr',
    autoDismiss: 1
  };

  if (err.response) {
    if (err.response.status === 400) {
      unsuccessfulOptions.title = title ? title : 'Please Try Again!';
      unsuccessfulOptions.message = err.response.data.error;
      dispatch(error(unsuccessfulOptions));
    } else if (err.response.status === 404) {
      // unsuccessfulOptions.title =
      //   err.response.data.message ||
      //   'Your request could not be processed. Please try again.';
      // dispatch(error(unsuccessfulOptions));
    } else if (err.response.status === 401) {
      unsuccessfulOptions.message = 'Unauthorized Access! Please login again';
      dispatch(signOut());
      dispatch(error(unsuccessfulOptions));
    } else if (err.response.status === 403) {
      unsuccessfulOptions.message =
        'Forbidden! You are not allowed to access this resource.';
      dispatch(error(unsuccessfulOptions));
    }
  } else if (err.message) {
    unsuccessfulOptions.message = err.message;
    dispatch(error(unsuccessfulOptions));
  } else {
    // fallback
    unsuccessfulOptions.message =
      'Your request could not be processed. Please try again.';
  }
};

export default handleError;
</file>
<file name="./client/app/utils/select.js" format="js">
/**
 *
 * select.js
 * this helper formulate data into select options
 */

export const formatSelectOptions = (data, empty = false, from) => {
  let newSelectOptions = [];

  if (data && data.length > 0) {
    data.map(option => {
      let newOption = {};
      newOption.value = option._id;
      newOption.label = option.name;
      newSelectOptions.push(newOption);
    });
  }

  if (empty) {
    const emptyOption = {
      value: 0,
      label: 'No option selected'
    };
    newSelectOptions.unshift(emptyOption);
  }

  return newSelectOptions;
};

export const unformatSelectOptions = data => {
  if (!data) return null;

  let newSelectOptions = [];

  if (data && data.length > 0) {
    data.map(option => {
      let newOption = {};
      newOption._id = option.value;
      newSelectOptions.push(newOption._id);
    });
  }

  return newSelectOptions;
};
</file>
<file name="./client/app/utils/base64.js" format="js">
/**
 *
 * base64.js
 * this helper formulate buffer data to base64 string
 */

export const arrayBufferToBase64 = buffer => {
  let binary = '';
  let bytes = [].slice.call(new Uint8Array(buffer.data.data));
  bytes.forEach((b) => binary += String.fromCharCode(b));
  return `data:${buffer.contentType};base64,${window.btoa(binary)}`;
};
</file>
<file name="./client/app/utils/store.js" format="js">
export const sortOptions = [
  { value: 0, label: 'Newest First' },
  { value: 1, label: 'Price High to Low' },
  { value: 2, label: 'Price Low to High' }
];
</file>
<file name="./client/app/utils/token.js" format="js">
/**
 *
 * token.js
 * axios default headers setup
 */

import axios from 'axios';

const setToken = token => {
  if (token) {
    axios.defaults.headers.common['Authorization'] = token;
  } else {
    delete axios.defaults.headers.common['Authorization'];
  }
};

export default setToken;
</file>
<file name="./client/app/utils/date.js" format="js">
/**
 *
 * date.js
 * this helper formulate date
 */

const today = new Date();

const dateOptions = {
  timeZone: 'UTC',
  weekday: 'long',
  year: 'numeric',
  month: 'short',
  day: 'numeric'
};

const timeOptions = {
  hour: 'numeric',
  minute: 'numeric'
};

// export const date = today.toLocaleDateString(undefined, dateOptions);
// export const time = today.toLocaleTimeString(undefined, timeOptions);

export const formatDate = date => {
  const newDate = new Date(date);

  //   const newDateOptions = {
  //     year: "numeric",
  //     month: "short",
  //     day: "numeric"
  //   };

  return newDate.toLocaleDateString('en-US', dateOptions);
};

export const formatTime = date => {
  const newDate = new Date(date);
  return newDate.toLocaleTimeString(undefined, timeOptions);
};
</file>
<file name="./client/app/utils/index.js" format="js">
const colors = [
  '#FF6633',
  '#FFB399',
  '#FF33FF',
  '#00B3E6',
  '#E6B333',
  '#3366E6',
  '#999966',
  '#99FF99',
  '#B34D4D',
  '#80B300',
  '#809900',
  '#E6B3B3',
  '#6680B3',
  '#66991A',
  '#FF99E6',
  '#CCFF1A',
  '#FF1A66',
  '#E6331A',
  '#33FFCC',
  '#66994D',
  '#B366CC',
  '#4D8000',
  '#B33300',
  '#CC80CC',
  '#66664D',
  '#991AFF',
  '#E666FF',
  '#4DB3FF',
  '#1AB399',
  '#E666B3',
  '#33991A',
  '#CC9999',
  '#B3B31A',
  '#00E680',
  '#4D8066',
  '#809980',
  '#E6FF80',
  '#1AFF33',
  '#999933',
  '#FF3380',
  '#CCCC00',
  '#66E64D',
  '#4D80CC',
  '#9900B3',
  '#E64D66',
  '#4DB380',
  '#FF4D4D',
  '#99E6E6',
  '#6666FF'
];

export const getRandomColors = () => {
  const index = Math.floor(Math.random() * colors.length);
  return colors[index];
};

let cache = {};
export const getMemoizedRandomColors = s => {
  const color = getRandomColors();

  if (s in cache) {
    return cache[s];
  } else {
    let result = color;
    cache[s] = result;
    return result;
  }
};
</file>
<file name="./client/app/utils/app.js" format="js">
import { ROLES, EMAIL_PROVIDER } from '../constants';

export const isProviderAllowed = provider =>
  provider === EMAIL_PROVIDER.Google || provider === EMAIL_PROVIDER.Facebook;

export const isDisabledMerchantAccount = user =>
  user.role === ROLES.Merchant &&
  user.merchant &&
  user.merchant.isActive === false;
</file>
<file name="./client/app/utils/validation.js" format="js">
import Validator from 'validatorjs';
import DOMPurify from 'dompurify';

export const allFieldsValidation = (data, rules, options) => {
  const validation = new Validator(data, rules, options);
  const validationResponse = { isValid: validation.passes() };
  if (!validationResponse.isValid) {
    validationResponse.errors = validation.errors.all();
  }

  return validationResponse;
};

export const santizeFields = data => {
  const fields = { ...data };

  for (let field in fields) {
    if (typeof field === 'string') {
      fields[field] = DOMPurify.sanitize(fields[field], {
        USE_PROFILES: { html: false }
      });
    }
  }
  return fields;
};
</file>
<file name="./client/app/index.js" format="js">
/**
 *
 * index.js
 * This is the entry file for the application
 */

import React from 'react';
import ReactDOM from 'react-dom';

import App from './app';

ReactDOM.render(<App />, document.getElementById('root'));
</file>
<file name="./client/app/constants/index.js" format="js">
export const API_URL = process.env.API_URL;

export const SOCKET_URL =
  window.location.host.indexOf('localhost') >= 0
    ? 'http://127.0.0.1:3000'
    : window.location.host;

export const ROLES = {
  Admin: 'ROLE ADMIN',
  Member: 'ROLE MEMBER',
  Merchant: 'ROLE MERCHANT'
};

export const CART_ITEMS = 'cart_items';
export const CART_TOTAL = 'cart_total';
export const CART_ID = 'cart_id';

export const CART_ITEM_STATUS = {
  Processing: 'Processing',
  Shipped: 'Shipped',
  Delivered: 'Delivered',
  Cancelled: 'Cancelled',
  Not_processed: 'Not processed'
};

export const MERCHANT_STATUS = {
  Rejected: 'Rejected',
  Approved: 'Approved',
  Waiting_Approval: 'Waiting Approval'
};

export const REVIEW_STATUS = {
  Rejected: 'Rejected',
  Approved: 'Approved',
  Waiting_Approval: 'Waiting Approval'
};

export const EMAIL_PROVIDER = {
  Email: 'Email',
  Google: 'Google',
  Facebook: 'Facebook'
};
</file>
<file name="./client/app/app.js" format="js">
/**
 *
 * app.js
 *
 */

import React from 'react';
import { Provider } from 'react-redux';
import { ConnectedRouter } from 'connected-react-router';

import store, { history } from './store';
import { SocketProvider } from './contexts/Socket';
import { SET_AUTH } from './containers/Authentication/constants';
import Application from './containers/Application';
import ScrollToTop from './scrollToTop';
import setToken from './utils/token';

// Import application sass styles
import './styles/style.scss';

// Import Font Awesome Icons Set
import 'font-awesome/css/font-awesome.min.css';

// Import Simple Line Icons Set
import 'simple-line-icons/css/simple-line-icons.css';

// react-bootstrap-table2 styles
import 'react-bootstrap-table-next/dist/react-bootstrap-table2.min.css';

// rc-slider style
import 'rc-slider/assets/index.css';

// Authentication
const token = localStorage.getItem('token');

if (token) {
  // authenticate api authorization
  setToken(token);

  // authenticate routes
  store.dispatch({ type: SET_AUTH });
}

const app = () => (
  <Provider store={store}>
    <ConnectedRouter history={history}>
      <SocketProvider>
        <ScrollToTop>
          <Application />
        </ScrollToTop>
      </SocketProvider>
    </ConnectedRouter>
  </Provider>
);

export default app;
</file>
<file name="./client/app/actions.js" format="js">
/**
 *
 * actions.js
 * actions configuration
 */

import { bindActionCreators } from 'redux';

import * as application from './containers/Application/actions';
import * as authentication from './containers/Authentication/actions';
import * as homepage from './containers/Homepage/actions';
import * as signup from './containers/Signup/actions';
import * as login from './containers/Login/actions';
import * as forgotPassword from './containers/ForgotPassword/actions';
import * as navigation from './containers/Navigation/actions';
import * as cart from './containers/Cart/actions';
import * as newsletter from './containers/Newsletter/actions';
import * as dashboard from './containers/Dashboard/actions';
import * as account from './containers/Account/actions';
import * as address from './containers/Address/actions';
import * as resetPassword from './containers/ResetPassword/actions';
import * as users from './containers/Users/actions';
import * as product from './containers/Product/actions';
import * as category from './containers/Category/actions';
import * as brand from './containers/Brand/actions';
import * as menu from './containers/NavigationMenu/actions';
import * as shop from './containers/Shop/actions';
import * as merchant from './containers/Merchant/actions';
import * as contact from './containers/Contact/actions';
import * as order from './containers/Order/actions';
import * as review from './containers/Review/actions';
import * as wishlist from './containers/WishList/actions';

export default function mapDispatchToProps(dispatch) {
  return bindActionCreators(
    {
      ...application,
      ...authentication,
      ...homepage,
      ...signup,
      ...login,
      ...forgotPassword,
      ...navigation,
      ...cart,
      ...newsletter,
      ...dashboard,
      ...account,
      ...address,
      ...resetPassword,
      ...users,
      ...product,
      ...category,
      ...brand,
      ...menu,
      ...shop,
      ...merchant,
      ...contact,
      ...order,
      ...review,
      ...wishlist
    },
    dispatch
  );
}
</file>
<file name="./client/Dockerfile" format="Dockerfile">
# Use official Node.js 14 as base image
FROM node:16.20.2-buster-slim

# Set working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the client code
COPY . .

RUN mv .env.example .env

# Build the client for production
RUN npm run build

# Expose port 8080 for the client
EXPOSE 8080

# Start the client
CMD [ "npm", "run", "dev" ]
</file>
<file name="./client/.env.example" format="example">
API_URL=http://localhost:3000/api</file>
<file name="./client/webpack/webpack.common.js" format="js">
const path = require('path');
const CopyWebpackPlugin = require('copy-webpack-plugin');

const CURRENT_WORKING_DIR = process.cwd();

module.exports = {
  entry: [path.join(CURRENT_WORKING_DIR, 'app/index.js')],
  resolve: {
    extensions: ['.js', '.json', '.css', '.scss', '.html'],
    alias: {
      app: 'app'
    }
  },
  module: {
    rules: [
      {
        test: /\.(js|jsx)$/,
        loader: 'babel-loader',
        exclude: /(node_modules)/
      }
    ]
  },
  plugins: [
    new CopyWebpackPlugin([
      {
        from: 'public'
      }
    ])
  ]
};
</file>
<file name="./client/webpack/webpack.dev.js" format="js">
const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const webpackMerge = require('webpack-merge');
const Dotenv = require('dotenv-webpack');

const common = require('./webpack.common');

const CURRENT_WORKING_DIR = process.cwd();

const config = {
  mode: 'development',
  output: {
    path: path.join(CURRENT_WORKING_DIR, '/dist'),
    filename: '[name].js',
    publicPath: '/'
  },
  module: {
    rules: [
      {
        test: /\.(scss|sass|css)$/,
        use: [
          'style-loader',
          {
            loader: 'css-loader'
          },
          {
            loader: 'postcss-loader',
            options: {
              plugins: () => [require('autoprefixer')]
            }
          },
          {
            loader: 'sass-loader'
          }
        ]
      },
      {
        test: /\.(png|jpg|jpeg|gif|svg|ico)$/,
        use: [
          {
            loader: 'file-loader',
            options: {
              outputPath: 'images',
              name: '[name].[ext]'
            }
          }
        ]
      },
      {
        test: /\.(woff(2)?|ttf|eot|svg)(\?v=\d+\.\d+\.\d+)?$/,
        use: [
          {
            loader: 'file-loader',
            options: {
              outputPath: 'fonts',
              name: '[name].[ext]'
            }
          }
        ]
      }
    ]
  },
  plugins: [
    new Dotenv(),
    new HtmlWebpackPlugin({
      template: path.join(CURRENT_WORKING_DIR, 'public/index.html'),
      inject: true
    })
  ],
  devServer: {
    port: 8080,
    open: true,
    inline: true,
    compress: true,
    host: '0.0.0.0',
    hot: true,
    disableHostCheck: true,
    historyApiFallback: true
  },
  devtool: 'eval-source-map'
};

module.exports = webpackMerge(common, config);
</file>
<file name="./client/webpack/webpack.prod.js" format="js">
require('dotenv').config();
const webpack = require('webpack');
const path = require('path');
const TerserPlugin = require('terser-webpack-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const WebpackPwaManifest = require('webpack-pwa-manifest');
const OptimizeCssAssetsPlugin = require('optimize-css-assets-webpack-plugin');
const webpackMerge = require('webpack-merge');

const common = require('./webpack.common');

const CURRENT_WORKING_DIR = process.cwd();
const NODE_ENV = process.env.NODE_ENV;
const API_URL = process.env.API_URL;

const config = {
  mode: 'production',
  output: {
    path: path.join(CURRENT_WORKING_DIR, '/dist'),
    filename: 'js/[name].[hash].js',
    publicPath: '/'
  },
  module: {
    rules: [
      {
        test: /\.(scss|sass|css)$/,
        use: [
          MiniCssExtractPlugin.loader,
          {
            loader: 'css-loader'
          },
          {
            loader: 'postcss-loader',
            options: {
              plugins: () => [require('cssnano'), require('autoprefixer')]
            }
          },
          {
            loader: 'sass-loader'
          }
        ]
      },
      {
        test: /\.(png|jpg|jpeg|gif|svg|ico)$/,
        use: [
          {
            loader: 'file-loader',
            options: {
              outputPath: 'images',
              publicPath: '../images',
              name: '[name].[hash].[ext]'
            }
          }
        ]
      },
      {
        test: /\.(woff(2)?|ttf|eot|svg)(\?v=\d+\.\d+\.\d+)?$/,
        use: [
          {
            loader: 'file-loader',
            options: {
              outputPath: 'fonts',
              publicPath: '../fonts',
              name: '[name].[hash].[ext]'
            }
          }
        ]
      }
    ]
  },
  performance: {
    hints: false,
    maxEntrypointSize: 512000,
    maxAssetSize: 512000
  },
  optimization: {
    minimize: true,
    nodeEnv: 'production',
    sideEffects: true,
    concatenateModules: true,
    runtimeChunk: 'single',
    splitChunks: {
      cacheGroups: {
        vendors: {
          test: /[\\/]node_modules[\\/]/,
          name: 'vendors',
          chunks: 'all'
        },
        styles: {
          test: /\.css$/,
          name: 'styles',
          chunks: 'all',
          enforce: true
        }
      }
    },
    minimizer: [
      new TerserPlugin({
        terserOptions: {
          warnings: false,
          compress: {
            comparisons: false
          },
          parse: {},
          mangle: true,
          output: {
            comments: false,
            ascii_only: true
          }
        }
      })
    ]
  },
  plugins: [
    new webpack.DefinePlugin({
      'process.env': {
        NODE_ENV: JSON.stringify(NODE_ENV),
        API_URL: JSON.stringify(API_URL)
      }
    }),
    new HtmlWebpackPlugin({
      template: path.join(CURRENT_WORKING_DIR, 'public/index.html'),
      inject: true,
      minify: {
        removeComments: true,
        collapseWhitespace: true,
        removeRedundantAttributes: true,
        useShortDoctype: true,
        removeEmptyAttributes: true,
        removeStyleLinkTypeAttributes: true,
        keepClosingSlash: true,
        minifyJS: true,
        minifyCSS: true,
        minifyURLs: true
      }
    }),
    new MiniCssExtractPlugin({
      filename: 'css/[name].[hash].css'
    }),
    new WebpackPwaManifest({
      name: 'MERN Store',
      short_name: 'MERNStore',
      description: 'MERN Store!',
      background_color: '#fff',
      theme_color: '#4a68aa',
      inject: true,
      ios: true,
      icons: [
        {
          src: path.resolve('public/images/pwa.png'),
          destination: 'images',
          sizes: [72, 96, 128, 144, 192, 384, 512]
        },
        {
          src: path.resolve('public/images/pwa.png'),
          sizes: [120, 152, 167, 180],
          destination: 'images',
          ios: true
        }
      ]
    }),
    new OptimizeCssAssetsPlugin({
      assetNameRegExp: /\.css$/g,
      cssProcessor: require('cssnano'),
      cssProcessorPluginOptions: {
        preset: ['default', { discardComments: { removeAll: true } }]
      },
      canPrint: true
    })
  ]
};

module.exports = webpackMerge(common, config);
</file>
<file name="./client/public/index.html" format="html">
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="X-UA-Compatible" content="ie=edge" />
    <link rel="icon" href="/images/favicon.ico" />
      <!--avoide catche store in browser-->
    <meta http-equiv='cache-control' content='no-cache'>
    <meta http-equiv='expires' content='0'>
    <meta http-equiv='pragma' content='no-cache'>
    <!---->
    <title>MERN Store</title>
  </head>
  <body>
    <noscript> You need to enable JavaScript to run this app. </noscript>
    <div id="root"></div>
  </body>
</html>
</file>
<file name="./client/package.json" format="json">
{
  "name": "client",
  "version": "1.0.0",
  "description": "MERN Ecommerce Client",
  "scripts": {
    "clean": "rimraf dist",
    "build": "npm run clean && cross-env NODE_ENV=production webpack --mode production --config webpack/webpack.prod.js",
    "dev": "cross-env NODE_ENV=development webpack-dev-server --config webpack/webpack.dev.js"
  },
  "engines": {
    "node": "16.16.0"
  },
  "dependencies": {
    "@fontsource/poppins": "^4.5.9",
    "autosuggest-highlight": "^3.1.1",
    "axios": "^0.21.1",
    "bootstrap": "^4.3.1",
    "connected-react-router": "^6.4.0",
    "dompurify": "^2.3.8",
    "dotenv": "^8.0.0",
    "font-awesome": "^4.7.0",
    "history": "^4.9.0",
    "mobile-detect": "^1.4.4",
    "rc-slider": "^9.7.2",
    "react": "^16.8.6",
    "react-autosuggest": "^10.1.0",
    "react-bootstrap-table-next": "^3.1.5",
    "react-bootstrap-table2-toolkit": "^2.0.1",
    "react-dom": "^16.8.6",
    "react-multi-carousel": "^2.5.5",
    "react-notification-system-redux": "^2.0.0",
    "react-paginate": "^8.1.3",
    "react-rating-stars-component": "^2.2.0",
    "react-redux": "^7.0.3",
    "react-router-dom": "^5.0.1",
    "react-select": "^3.0.4",
    "react-share": "^4.4.0",
    "reactstrap": "^8.0.0",
    "redux": "^4.0.1",
    "redux-thunk": "^2.3.0",
    "sass": "^1.32.12",
    "simple-line-icons": "^2.4.1",
    "socket.io-client": "^4.2.0",
    "validatorjs": "^3.18.1"
  },
  "devDependencies": {
    "@babel/core": "^7.4.5",
    "@babel/plugin-proposal-class-properties": "^7.14.5",
    "@babel/preset-env": "^7.4.5",
    "@babel/preset-react": "^7.0.0",
    "autoprefixer": "^9.6.0",
    "babel-loader": "^8.0.6",
    "chalk": "^2.4.2",
    "copy-webpack-plugin": "^5.0.3",
    "cross-env": "^5.2.1",
    "css-loader": "^2.1.1",
    "cssnano": "^4.1.10",
    "dotenv-webpack": "^1.8.0",
    "file-loader": "^4.0.0",
    "html-webpack-plugin": "^3.2.0",
    "mini-css-extract-plugin": "^0.7.0",
    "optimize-css-assets-webpack-plugin": "^5.0.1",
    "postcss-loader": "^3.0.0",
    "rimraf": "^2.6.3",
    "sass-loader": "^10.2.0",
    "style-loader": "^0.23.1",
    "terser-webpack-plugin": "^1.3.0",
    "webpack": "^4.46.0",
    "webpack-cli": "^3.3.12",
    "webpack-dev-server": "^3.11.2",
    "webpack-merge": "^4.2.1",
    "webpack-pwa-manifest": "^4.0.0"
  }
}
</file>
<file name="./README.md" format="md">
# MERN Ecommerce

## Description

An ecommerce store built with MERN stack, and utilizes third party API's. This ecommerce store enable three main different flows or implementations:

1. Buyers browse the store categories, products and brands
2. Sellers or Merchants manage their own brand component
3. Admins manage and control the entire store components 


* features:
  * Node provides the backend environment for this application
  * Express middleware is used to handle requests, routes
  * Mongoose schemas to model the application data
  * React for displaying UI components
  * Redux to manage application's state
  * Redux Thunk middleware to handle asynchronous redux actions

## Quickstart Guide

To run this project locally you can use docker compose provided in the repository. Here is a guide on how to run this project locally using docker compose.

Clone the repository
```
$ git clone https://github.com/mohamedsamara/mern-ecommerce.git
```

Edit the dockercompose.yml file and update the the values for MONGO_URI and JWT_SECRET

Then simply start the docker compose:
```
$ docker compose -f dockercompose.yml up
```

## Database Seed

* The seed command will create an admin user in the database
* The email and password are passed with the command as arguments
* Like below command, replace brackets with email and password. 
* For more information, see code [here](server/utils/seed.js)

```
npm run seed:db [email-***@****.com] [password-******] // This is just an example.
```

## Demo

This application is deployed on Vercel Please check it out :smile: [here](https://mern-store-gold.vercel.app).

See admin dashboard [demo](https://mernstore-bucket.s3.us-east-2.amazonaws.com/admin.mp4)

## Install

Some basic Git commands are:

```
$ git clone https://github.com/mohamedsamara/mern-ecommerce.git
$ cd project
$ npm install
```

## Start development

```
$ npm run dev
```

## Simple build for production

```
$ npm run build
```

## Run build for production

```
$ npm start
```


## Languages & tools

- [Node](https://nodejs.org/en/)

- [Express](https://expressjs.com/)

- [Mongoose](https://mongoosejs.com/)

- [React](https://reactjs.org/)

- [Webpack](https://webpack.js.org/)


### Code Formatter

- Add a `.vscode` directory
- Create a file `settings.json` inside `.vscode`
- Install Prettier - Code formatter in VSCode
- Add the following snippet:  

```json

    {
      "editor.formatOnSave": true,
      "prettier.singleQuote": true,
      "prettier.arrowParens": "avoid",
      "prettier.jsxSingleQuote": true,
      "prettier.trailingComma": "none",
      "javascript.preferences.quoteStyle": "single",
    }

```

</file>
<file name="./package.json" format="json">
{
  "name": "mern-ecommerce",
  "version": "1.0.0",
  "description": "MERN Ecommerce",
  "main": "server/index.js",
  "scripts": {
    "dev": "npm-run-all --parallel dev:*",
    "dev:client": "cd client && npm run dev",
    "dev:server": "cd server && npm run dev",
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "repository": {
    "type": "git",
    "url": "git+https://github.com/mohamedsamara/mern-ecommerce.git"
  },
  "keywords": [
    "node",
    "express",
    "mongoose",
    "react",
    "redux",
    "redux-thunk",
    "webpack"
  ],
  "author": "Mohamed Samara (https://github.com/mohamedsamara)",
  "license": "MIT",
  "bugs": {
    "url": "https://github.com/mohamedsamara/mern-ecommerce/issues"
  },
  "homepage": "https://github.com/mohamedsamara/mern-ecommerce#readme",
  "devDependencies": {
    "cross-env": "^5.2.1",
    "npm-run-all": "^4.1.5"
  }
}
</file>
