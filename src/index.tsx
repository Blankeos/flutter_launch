import { root } from '@lynx-js/react';

import { MemoryRouter, Route, Routes } from 'react-router';
import { App } from './App.jsx';
import { type PageRoute } from './constants/page-routes.js';
import { AuthPage } from './pages/auth.js';
import { OnboardingPage } from './pages/onboarding.js';

const cpath = (path: PageRoute) => path;

root.render(
  <MemoryRouter>
    <Routes>
      <Route path={cpath('/')} element={<OnboardingPage />} />
      <Route path={cpath('/onboarding')} element={<OnboardingPage />} />
      <Route path={cpath('/auth')} element={<AuthPage />} />
      <Route path={cpath('/app')} element={<App />} />
      <Route path={cpath('/restaurants')} element={<App />} />
      <Route path={cpath('/restaurants/:id')} element={<App />} />
      <Route path={cpath('/restaurants/:id/menu')} element={<App />} />

      <Route path={cpath('/cart')} element={<App />} />
      <Route path={cpath('/checkout')} element={<App />} />
      <Route path={cpath('/order-confirmation')} element={<App />} />
      <Route path={cpath('/profile')} element={<App />} />
      <Route path={cpath('/settings')} element={<App />} />
    </Routes>
  </MemoryRouter>,
);

if (import.meta.webpackHot) {
  import.meta.webpackHot.accept();
}
