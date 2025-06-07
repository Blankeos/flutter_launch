export { $path, pageRoutes };
export type { PageRoute, UseParamsResult };

const pageRoutes = [
  '/',
  '/onboarding',
  '/profile',
  '/settings',
  '/auth',
  '/app',
  '/cart',
  '/checkout',
  '/order-confirmation',
  '/restaurants',
  '/restaurants/:id',
  '/restaurants/:id/menu',
] as const;

type PageRoute = (typeof pageRoutes)[number];

/* For regular routes with named parameters. But it has a minor issue, it gets "" as a property, so this is prefixed with '_' */
type _ExtractNamedParams<T extends string> =
  T extends `${string}:${infer Param}/${infer Rest}`
    ? { [K in Param | keyof ExtractNamedParams<Rest>]: string }
    : T extends `${string}:${infer Param}`
      ? { [K in Param]: string }
      : {};

/** Minor utility to prevent typescript from wrapping types. */
type Prettify<T> = {
  [K in keyof T]: T[K];
} & {};

/* For regular routes with named parameters */
type ExtractNamedParams<T extends string> = Prettify<
  Omit<_ExtractNamedParams<T>, ''>
>;

/* Helper to determine if a route ends with a catch-all segment */
type EndsWithCatchall<T extends string> = T extends `${string}/:`
  ? true
  : false;

/* Conditional type helper for determining if a route is a catchall/splat route */
type IsCatchallRoute<T extends string> = EndsWithCatchall<T>;

/* Return type for UseParams */
type UseParamsResult<T extends PageRoute> =
  IsCatchallRoute<T> extends true
    ? ExtractNamedParams<T> & { ':': string[]; '_:': string }
    : ExtractNamedParams<T>;

/* Conditional type helper for determining if a route has parameters */
type HasParams<T extends string> =
  IsCatchallRoute<T> extends true
    ? true
    : T extends `${string}:${string}`
      ? true
      : false;

/* Type for the options of the getRoute function. */
type GetRouteOptions<T extends PageRoute> =
  HasParams<T> extends true
    ? IsCatchallRoute<T> extends true
      ? {
          params: ExtractNamedParams<T> & { ':': string[] | string };
          search?: Record<string, string>;
        }
      : {
          params: ExtractNamedParams<T>;
          search?: Record<string, string>;
        }
    : {
        params?: never;
        search?: Record<string, string>;
      };

/* Typesafe helper to generate a route URL based on Vike pages folder. */
function $path<T extends PageRoute>(
  route: T,
  ...args: HasParams<T> extends true
    ? [options: GetRouteOptions<T>]
    : [options?: GetRouteOptions<T>]
): string {
  const options = args[0] || {};

  // Handle both regular named parameters and catchall routes
  let result: string = route;

  if (options.params) {
    // Handle named parameters first
    const params = { ...options.params } as Record<string, string | string[]>; // Explicitly type params
    Object.entries(params).forEach(([key, value]) => {
      if (key !== ':') {
        result = result.replace(`:${key}`, String(value));
      } else if (Array.isArray(value)) {
        result = result.replace(':', value.join('/'));
      } else {
        result = result.replace(':', value);
      }
    });
  }

  return result;
}
