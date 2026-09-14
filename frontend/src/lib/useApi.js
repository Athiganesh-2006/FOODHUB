import { useCallback, useEffect, useRef, useState } from 'react';
import api from '../api/client';

/**
 * Small GET helper with loading/error state and a manual `reload`.
 *
 * Options:
 *   params   query params object
 *   skip     hold off until inputs are ready
 *   pollMs   when > 0, re-fetch every pollMs in the background.
 *
 * Background re-fetches deliberately do NOT touch `loading` or `error`: the
 * page keeps showing the data it already has, so a poll never flashes a
 * spinner over content the user is reading, and a brief network blip does not
 * replace a working screen with an error. Polling also pauses while the tab is
 * hidden and fires once immediately on re-focus, so switching back to the tab
 * shows current data without a manual refresh.
 */
export function useApi(url, options = {}) {
  const { params, skip = false, pollMs = 0 } = options;
  const paramsKey = JSON.stringify(params || null);

  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(!skip);
  const [error, setError] = useState(null);

  // Keeps the latest fetch available to the interval/focus handlers without
  // making them a dependency (which would tear down the timer every render).
  const fetchRef = useRef(null);

  const fetchData = useCallback(
    async (background = false) => {
      if (skip || !url) return;
      if (!background) {
        setLoading(true);
        setError(null);
      }
      try {
        const res = await api.get(url, params ? { params } : undefined);
        setData(res.data);
        if (background) setError(null);
      } catch (e) {
        if (!background) setError(e.message || 'Failed to load');
      } finally {
        if (!background) setLoading(false);
      }
    },
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [url, paramsKey, skip]
  );

  // Assigned in an effect rather than during render: mutating a ref while
  // rendering is not a safe React pattern. This effect is declared before the
  // polling effect below, so the ref is populated before any timer starts.
  useEffect(() => {
    fetchRef.current = fetchData;
  }, [fetchData]);

  const reload = useCallback(() => fetchData(false), [fetchData]);

  useEffect(() => {
    fetchData(false);
  }, [fetchData]);

  useEffect(() => {
    if (!pollMs || skip || !url) return undefined;

    let timer = null;
    const tick = () => {
      // Don't poll a tab nobody is looking at.
      if (document.visibilityState === 'visible') fetchRef.current?.(true);
    };
    const start = () => {
      if (timer === null) timer = setInterval(tick, pollMs);
    };
    const stop = () => {
      if (timer !== null) {
        clearInterval(timer);
        timer = null;
      }
    };
    const onVisibility = () => {
      if (document.visibilityState === 'visible') {
        fetchRef.current?.(true); // catch up right away
        start();
      } else {
        stop();
      }
    };

    if (document.visibilityState === 'visible') start();
    document.addEventListener('visibilitychange', onVisibility);
    window.addEventListener('focus', onVisibility);
    return () => {
      stop();
      document.removeEventListener('visibilitychange', onVisibility);
      window.removeEventListener('focus', onVisibility);
    };
  }, [pollMs, skip, url, paramsKey]);

  return { data, loading, error, reload, setData };
}
