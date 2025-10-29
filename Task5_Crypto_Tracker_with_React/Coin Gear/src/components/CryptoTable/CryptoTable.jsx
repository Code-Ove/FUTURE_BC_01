import React from 'react';
import {
  Table,
  Thead,
  Tbody,
  Tr,
  Th,
  Td,
  Image,
  Text,
  HStack,
  Button,
  Box,
  TableContainer,
  Alert,
  AlertIcon,
} from '@chakra-ui/react';
import { FaPlus } from 'react-icons/fa';

const CryptoTable = ({ cryptoData, onAddToPortfolio }) => {
  if (!cryptoData || !Array.isArray(cryptoData)) {
    return (
      <Alert status="error" borderRadius="lg">
        <AlertIcon />
        Invalid cryptocurrency data received.
      </Alert>
    );
  }

  if (cryptoData.length === 0) {
    return (
      <Alert status="info" borderRadius="lg">
        <AlertIcon />
        No cryptocurrencies found. Try adjusting your search.
      </Alert>
    );
  }

  return (
    <Box bg="white" borderRadius="lg" boxShadow="sm" overflow="hidden">
      <TableContainer>
        <Table variant="simple">
          <Thead>
            <Tr>
              <Th>Coin</Th>
              <Th>Price</Th>
              <Th>24h Change</Th>
              <Th>Market Cap</Th>
              <Th>Action</Th>
            </Tr>
          </Thead>
          <Tbody>
            {cryptoData.map((coin) => (
              <Tr key={coin.id} _hover={{ bg: 'gray.50' }}>
                <Td>
                  <HStack spacing={2}>
                    {coin.image && (
                      <Image
                        src={coin.image}
                        alt={coin.name}
                        boxSize="24px"
                        fallback={<Box boxSize="24px" bg="gray.200" borderRadius="full" />}
                      />
                    )}
                    <Text fontWeight="medium">{coin.name}</Text>
                    <Text color="gray.500">({coin.symbol?.toUpperCase()})</Text>
                  </HStack>
                </Td>
                <Td fontWeight="medium">
                  ${typeof coin.current_price === 'number' ? coin.current_price.toLocaleString() : 'N/A'}
                </Td>
                <Td>
                  <Text
                    color={coin.price_change_percentage_24h > 0 ? 'green.500' : 'red.500'}
                    fontWeight="medium"
                  >
                    {typeof coin.price_change_percentage_24h === 'number'
                      ? `${coin.price_change_percentage_24h.toFixed(2)}%`
                      : 'N/A'}
                  </Text>
                </Td>
                <Td>
                  ${typeof coin.market_cap === 'number' ? coin.market_cap.toLocaleString() : 'N/A'}
                </Td>
                <Td>
                  <Button
                    leftIcon={<FaPlus />}
                    colorScheme="blue"
                    size="sm"
                    onClick={() => onAddToPortfolio(coin)}
                    variant="solid"
                    _hover={{
                      transform: 'translateY(-1px)',
                      boxShadow: 'sm',
                    }}
                    transition="all 0.2s"
                    isDisabled={!coin.id}
                  >
                    Add
                  </Button>
                </Td>
              </Tr>
            ))}
          </Tbody>
        </Table>
      </TableContainer>
    </Box>
  );
};

export default CryptoTable;