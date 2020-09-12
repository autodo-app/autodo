import * as React from 'react';

import Layout from '../components/landing/Layout';
import SEO from '../components/landing/SEO';
import ValueProp from '../components/landing/ValueProp';
import SocialProof from '../components/landing/SocialProof';
import ProductBenefits from '../components/landing/ProductBenefits';
import ProductFeatures from '../components/landing/ProductFeatures';
import Testimonials from '../components/landing/Testimonials';
import CallToAction from '../components/landing/CallToAction';

const IndexPage = () => (
  <Layout>
    <SEO title="Home" />
    <ValueProp />
    <SocialProof />
    <ProductBenefits />
    <ProductFeatures />
    <Testimonials />
    <CallToAction />
  </Layout>
);

export default IndexPage;
