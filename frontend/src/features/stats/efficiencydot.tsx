import * as React from 'react';

export const EfficiencyDot = (props: any): JSX.Element => {
  const { cx, cy, stroke, value, data } = props;
  console.log(data);
  const RADIUS = 5;

  const minMeasure = Math.min(...data.map((e: any) => e.raw ?? 99999));
  const maxMeasure = Math.max(...data.map((e: any) => e.raw ?? 0));
  const scale = (value - minMeasure) / (maxMeasure - minMeasure);
  const hue = scale * 120;
  const fill = `hsl(${hue}, 100%, 50%)`;

  if (!value) {
    return <></>;
  }
  return (
    <svg fill={fill}>
      <circle cx={cx} cy={cy} stroke={stroke} r={RADIUS} />
    </svg>
  );
};
