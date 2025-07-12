
export const trackMetric = async (endpoint: string) => {
  try {
    const baseUrl = (window as any).__ENV__?.VITE_METRICS_API_URL;
    if(!baseUrl) {
      console.warn("Metrics API URL is not defined. Ensure VITE_METRICS_API_URL is set.");
      return;
    }
    await fetch(`${baseUrl}/${endpoint}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
    });
  } catch (err) {
    console.error('Failed to send metric:', err);
  }
};
