import * as React from 'react';
import { Theme, makeStyles } from '@material-ui/core';

// @ts-ignore
import AddTasks from '../../assets/undraw/undraw_add_tasks_mxew.svg';
// @ts-ignore
import FileSync from '../../assets/undraw/undraw_file_sync_ot38.svg';
// @ts-ignore
import VisualData from '../../assets/undraw/undraw_visual_data_b1wx.svg';

interface StyleProps {
  productBenefits: React.CSSProperties;
  productBenefitsGroup: React.CSSProperties;
  productBenefits1Image: React.CSSProperties;
  productBenefits1Tagline: React.CSSProperties;
  productBenefits2Image: React.CSSProperties;
  productBenefits2Tagline: React.CSSProperties;
  productBenefits3Image: React.CSSProperties;
  productBenefits3Tagline: React.CSSProperties;
}

type StyleClasses = Record<keyof StyleProps, string>;

const useStyles = makeStyles<Theme, StyleProps>(
  (theme: Theme) =>
    ({
      productBenefits: {
        backgroundColor: '#eee',
        padding: '3em 0',
      },
      productBenefitsGroup: {
        maxWidth: '75rem',
        margin: '0 auto',
        display: 'grid',
        gridTemplateColumns: 'repeat(8, 1fr)',
        gridTemplateRows: 'repeat(6, minmax(10rem, 1fr))',
        gridGap: '2em',
        alignItems: 'center',
        justifyItems: 'center',
        width: '90%',
      },
      productBenefit1Tagline: {
        gridRow: '1/2',
        gridColumn: '1/9',
        fontSize: '2rem',
        fontWeight: 600,
        width: '100%',
        [theme.breakpoints.up('sm')]: {
          gridRow: '1/3',
          gridColumn: '5/9',
        },
      },
      productBenefit1Image: {
        gridRow: '2/3',
        gridColumn: 'span 8',
        background: `url(${AddTasks}) no-repeat center`,
        backgroundSize: 'contain',
        width: '100%',
        height: '100%',
        [theme.breakpoints.up('sm')]: {
          gridRow: '1/3',
          gridColumn: '1/4',
        },
      },
      productBenefit2Tagline: {
        gridRow: '3/4',
        gridColumn: '1/9',
        fontSize: '2rem',
        fontWeight: 600,
        width: '100%',
        [theme.breakpoints.up('sm')]: {
          gridRow: '3/5',
          gridColumn: '1/4',
        },
      },
      productBenefit2Image: {
        gridRow: '4/5',
        gridColumn: 'span 8',
        background: `url(${FileSync}) no-repeat center`,
        backgroundSize: 'contain',
        width: '100%',
        height: '100%',
        [theme.breakpoints.up('sm')]: {
          gridRow: '3/5',
          gridColumn: '5/9',
        },
      },
      productBenefit3Tagline: {
        gridRow: '5/6',
        gridColumn: 'span 8',
        fontSize: '2rem',
        fontWeight: 600,
        width: '100%',
        [theme.breakpoints.up('sm')]: {
          gridRow: '5/7',
          gridColumn: '5/9',
        },
      },
      productBenefit3Image: {
        gridRow: '6/7',
        gridColumn: 'span 8',
        background: `url(${VisualData}) no-repeat center`,
        backgroundSize: 'contain',
        width: '100%',
        height: '100%',
        [theme.breakpoints.up('sm')]: {
          gridRow: '5/7',
          gridColumn: '1/4',
        },
      },
    } as any),
);

const ProductBenefits = (props: any) => {
  const classes = useStyles({} as StyleProps);
  return (
    <section id="about" className={classes.productBenefits}>
      <div className={classes.productBenefitsGroup}>
        <div className={classes.productBenefit1Tagline}>
          Get reminders for your car's routine maintenance that work.
        </div>
        <div className={classes.productBenefit1Image}></div>
        <div className={classes.productBenefit2Tagline}>
          Keep track of your car on any device.
        </div>
        <div className={classes.productBenefit2Image}></div>
        <div className={classes.productBenefit3Tagline}>
          Every logged refueling improves the notifications for tasks.
        </div>
        <div className={classes.productBenefit3Image}></div>
      </div>
    </section>
  );
};

export default ProductBenefits;
